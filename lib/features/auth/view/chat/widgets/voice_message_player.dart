import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// WhatsApp-style audio message bubble with play/pause, progress bar, and duration.
class VoiceMessagePlayer extends StatefulWidget {
  final String audioPath;
  final bool isMe;
  final int durationMs;

  const VoiceMessagePlayer({
    super.key,
    required this.audioPath,
    required this.isMe,
    this.durationMs = 0,
  });

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _total = Duration.zero;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _total = Duration(milliseconds: widget.durationMs);

    _player.onPlayerStateChanged.listen((s) {
      if (mounted) {
        setState(() => _playerState = s);
        if (s == PlayerState.playing) {
          _waveController.repeat(reverse: true);
        } else {
          _waveController.stop();
        }
        if (s == PlayerState.completed) {
          setState(() => _position = Duration.zero);
        }
      }
    });

    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _total = d);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_playerState == PlayerState.playing) {
      await _player.pause();
    } else {
      final source = widget.audioPath.startsWith('/')
          ? DeviceFileSource(widget.audioPath)
          : UrlSource(widget.audioPath);
      await _player.play(source);
    }
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _playerState == PlayerState.playing;
    final progress = _total.inMilliseconds > 0
        ? (_position.inMilliseconds / _total.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    final bubbleColor = widget.isMe
        ? const Color(0xFF4A90E2)
        : Colors.white;
    final iconColor = widget.isMe ? Colors.white : const Color(0xFF4A90E2);
    final textColor = widget.isMe ? Colors.white70 : Colors.grey.shade600;
    final sliderActive = widget.isMe ? Colors.white : const Color(0xFF4A90E2);
    final sliderInactive = widget.isMe
        ? Colors.white38
        : Colors.grey.shade300;

    return Container(
      width: 230,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Play/Pause button
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: widget.isMe
                    ? Colors.white.withOpacity(0.25)
                    : const Color(0xFF4A90E2).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: iconColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Progress + waveform
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Waveform / progress bar
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Background waveform bars
                    _buildWaveformBars(progress, sliderActive, sliderInactive),
                    // Slider on top (transparent, for touch)
                    SliderTheme(
                      data: SliderThemeData(
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 5),
                        overlayShape: SliderComponentShape.noOverlay,
                        trackHeight: 0,
                        thumbColor: sliderActive,
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.transparent,
                      ),
                      child: Slider(
                        value: progress.toDouble(),
                        onChanged: (v) async {
                          final newPos = Duration(
                              milliseconds:
                                  (v * _total.inMilliseconds).toInt());
                          await _player.seek(newPos);
                        },
                      ),
                    ),
                  ],
                ),
                // Time
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    isPlaying
                        ? _fmt(_position)
                        : _total > Duration.zero
                            ? _fmt(_total)
                            : '0:00',
                    style: TextStyle(fontSize: 11, color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformBars(
      double progress, Color active, Color inactive) {
    const bars = 28;
    // A fixed waveform pattern (similar to WhatsApp)
    const heights = [
      6, 10, 15, 8, 18, 12, 20, 9, 16, 7, 22, 11, 17, 8,
      20, 13, 18, 6, 15, 10, 19, 7, 16, 12, 20, 8, 14, 6,
    ];

    return SizedBox(
      height: 28,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(bars, (i) {
          final fraction = i / bars;
          final isActive = fraction <= progress;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                height: heights[i % heights.length].toDouble(),
                decoration: BoxDecoration(
                  color: isActive ? active : inactive,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
