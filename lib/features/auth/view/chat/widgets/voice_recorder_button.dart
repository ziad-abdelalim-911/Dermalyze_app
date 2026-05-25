import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

/// WhatsApp-style voice recorder button.
/// Long-press → start recording (with live timer + slide-to-cancel).
/// Release → send. Slide left beyond threshold → cancel.
class VoiceRecorderButton extends StatefulWidget {
  final VoidCallback onSend;
  final VoidCallback onCancel;
  final Function(String path, int durationMs) onRecordingComplete;
  final VoidCallback? onRecordingStart;

  const VoiceRecorderButton({
    super.key,
    required this.onSend,
    required this.onCancel,
    required this.onRecordingComplete,
    this.onRecordingStart,
  });

  @override
  State<VoiceRecorderButton> createState() => _VoiceRecorderButtonState();
}

class _VoiceRecorderButtonState extends State<VoiceRecorderButton>
    with TickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  bool _isCancelled = false;
  bool _isLocked = false;
  double _dragDx = 0;
  double _dragDy = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _filePath;
  int _startMs = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  static const double _cancelThreshold = -80.0;
  static const double _lockThreshold = -40.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return;

    final dir = await getTemporaryDirectory();
    _filePath = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _startMs = DateTime.now().millisecondsSinceEpoch;

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
      path: _filePath!,
    );

    setState(() {
      _isRecording = true;
      _isCancelled = false;
      _isLocked = false;
      _dragDx = 0;
      _dragDy = 0;
      _seconds = 0;
    });

    widget.onRecordingStart?.call();

    HapticFeedback.mediumImpact();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  Future<void> _stopRecording({required bool cancelled}) async {
    _timer?.cancel();
    final path = await _recorder.stop();
    final durationMs = DateTime.now().millisecondsSinceEpoch - _startMs;

    setState(() {
      _isRecording = false;
      _isLocked = false;
      _dragDx = 0;
      _dragDy = 0;
    });

    if (!cancelled && path != null && durationMs > 500) {
      widget.onRecordingComplete(path, durationMs);
    } else {
      widget.onCancel();
      // Delete the temp file
      if (path != null) {
        try { File(path).deleteSync(); } catch (_) {}
      }
    }
  }

  String _formatTime(int secs) {
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRecording) {
      // Normal mic button (not recording)
      return GestureDetector(
        onLongPressStart: (_) => _startRecording(),
        onLongPressMoveUpdate: (details) {
          setState(() {
            _dragDx = details.offsetFromOrigin.dx;
            _dragDy = details.offsetFromOrigin.dy;
          });
          if (_dragDy < _lockThreshold && !_isLocked) {
            setState(() => _isLocked = true);
            HapticFeedback.heavyImpact();
          } else if (_dragDx < _cancelThreshold && !_isCancelled && !_isLocked) {
            setState(() => _isCancelled = true);
            HapticFeedback.lightImpact();
          }
        },
        onLongPressEnd: (_) {
          if (!_isLocked) _stopRecording(cancelled: _isCancelled);
        },
        onLongPressCancel: () {
          if (!_isLocked) _stopRecording(cancelled: true);
        },
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF2AABEE), Color(0xFF1A86C8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2AABEE).withOpacity(0.45),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.mic, color: Colors.white, size: 22),
        ),
      );
    }

    // Recording state – full-width bar overlay
    return _buildRecordingBar();
  }

  Widget _buildRecordingBar() {
    final cancelled = _dragDx < _cancelThreshold && !_isLocked;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: cancelled ? Colors.red.shade50 : const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: cancelled ? Colors.red.shade200 : const Color(0xFFBFDBFE),
        ),
      ),
      child: Row(
        children: [
          if (_isLocked) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 26),
              onPressed: () => _stopRecording(cancelled: true),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
          ] else ...[
            const SizedBox(width: 12),
            ScaleTransition(
              scale: _pulseAnim,
              child: Icon(
                Icons.mic,
                color: cancelled ? Colors.red : const Color(0xFF4A90E2),
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          // Timer
          Text(
            _formatTime(_seconds),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E3A8A),
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 8),
          
          // Waveform
          Expanded(child: _buildWaveform(cancelled)),
          
          if (_isLocked) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _stopRecording(cancelled: false),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4A90E2),
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 8),
          ] else ...[
            AnimatedOpacity(
              opacity: cancelled ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left, color: Colors.grey.shade500, size: 18),
                  Text(
                    'Cancel',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            if (cancelled)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'Release to cancel',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            // The mic button (draggable handle)
            GestureDetector(
              onLongPressMoveUpdate: (details) {
                if (_isLocked) return;
                setState(() {
                  _dragDx = details.offsetFromOrigin.dx;
                  _dragDy = details.offsetFromOrigin.dy;
                });
                if (_dragDy < _lockThreshold && !_isLocked) {
                  setState(() => _isLocked = true);
                  HapticFeedback.heavyImpact();
                } else if (_dragDx < _cancelThreshold && !_isCancelled && !_isLocked) {
                  setState(() => _isCancelled = true);
                  HapticFeedback.lightImpact();
                }
              },
              onLongPressEnd: (_) {
                if (!_isLocked) _stopRecording(cancelled: _isCancelled);
              },
              onLongPressCancel: () {
                if (!_isLocked) _stopRecording(cancelled: true);
              },
              child: Transform.translate(
                offset: Offset(_dragDx.clamp(-60.0, 0.0), (_dragDy < 0 ? _dragDy : 0.0).clamp(-20.0, 0.0)),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cancelled ? Colors.red : const Color(0xFF4A90E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 22),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }

  Widget _buildWaveform(bool cancelled) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(12, (i) {
            final phase = (i / 12 + _pulseController.value) % 1.0;
            final height = 6.0 + 14.0 * (0.5 + 0.5 * (phase < 0.5 ? phase * 2 : (1 - phase) * 2));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 3,
                height: height,
                decoration: BoxDecoration(
                  color: cancelled
                      ? Colors.red.shade300
                      : const Color(0xFF4A90E2).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
