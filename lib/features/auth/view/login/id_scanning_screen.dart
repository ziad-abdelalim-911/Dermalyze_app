import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// ── Result returned to caller ────────────────────────────────────────────────
class IdScanResult {
  final File frontCard;
  final File backCard;
  final File selfie;

  const IdScanResult({
    required this.frontCard,
    required this.backCard,
    required this.selfie,
  });
}

// ── Scan step ─────────────────────────────────────────────────────────────────
enum _ScanStep { frontCard, backCard, selfie, approved, declined }

// ─────────────────────────────────────────────────────────────────────────────
class IdScanningScreen extends StatefulWidget {
  const IdScanningScreen({super.key});

  @override
  State<IdScanningScreen> createState() => _IdScanningScreenState();
}

class _IdScanningScreenState extends State<IdScanningScreen>
    with SingleTickerProviderStateMixin {
  // ── state ──────────────────────────────────────────────────────────────────
  _ScanStep _step = _ScanStep.frontCard;
  File? _frontCard;
  File? _backCard;
  File? _selfie;

  // ── camera ─────────────────────────────────────────────────────────────────
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _cameraReady = false;
  bool _capturing = false;
  bool _flashOn = false;

  // ── animation ──────────────────────────────────────────────────────────────
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // ── palette ────────────────────────────────────────────────────────────────
  static const _teal = Color(0xFF4ECDC4);
  static const _darkBg = Color(0xFF0A0A0A);

  // ── lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _initCamera(front: false);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  // ── camera initialisation ──────────────────────────────────────────────────
  Future<void> _initCamera({required bool front}) async {
    setState(() => _cameraReady = false);

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final desc = _cameras.firstWhere(
        (c) => c.lensDirection ==
            (front ? CameraLensDirection.front : CameraLensDirection.back),
        orElse: () => _cameras.first,
      );

      await _cameraController?.dispose();

      _cameraController = CameraController(
        desc,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) setState(() => _cameraReady = true);
    } catch (_) {
      // camera unavailable – silently ignore (emulator / simulator)
    }
  }

  // ── capture ────────────────────────────────────────────────────────────────
  Future<void> _capture() async {
    if (_capturing || _cameraController == null || !_cameraReady) return;
    setState(() => _capturing = true);

    try {
      final xFile = await _cameraController!.takePicture();
      final file = File(xFile.path);

      if (_step == _ScanStep.frontCard) {
        _frontCard = file;
        // Switch to back → rear cam (already rear, just update step)
        setState(() {
          _step = _ScanStep.backCard;
          _capturing = false;
        });
      } else if (_step == _ScanStep.backCard) {
        _backCard = file;
        // Switch to selfie → front camera
        await _initCamera(front: true);
        setState(() {
          _step = _ScanStep.selfie;
          _capturing = false;
        });
      } else if (_step == _ScanStep.selfie) {
        _selfie = file;
        setState(() {
          _step = _ScanStep.approved;
          _capturing = false;
        });
        // Auto-close after 2 s
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(
            context,
            IdScanResult(
              frontCard: _frontCard!,
              backCard: _backCard!,
              selfie: _selfie!,
            ),
          );
        }
      }
    } catch (_) {
      setState(() {
        _step = _ScanStep.declined;
        _capturing = false;
      });
    }
  }

  // ── toggle flash ───────────────────────────────────────────────────────────
  Future<void> _toggleFlash() async {
    _flashOn = !_flashOn;
    try {
      await _cameraController?.setFlashMode(
          _flashOn ? FlashMode.torch : FlashMode.off);
    } catch (_) {}
    setState(() {});
  }

  // ── retry ──────────────────────────────────────────────────────────────────
  void _retry() {
    _initCamera(front: false);
    setState(() {
      _step = _ScanStep.frontCard;
      _frontCard = null;
      _backCard = null;
      _selfie = null;
      _flashOn = false;
    });
  }

  // ── helpers ────────────────────────────────────────────────────────────────
  String get _subtitle {
    switch (_step) {
      case _ScanStep.frontCard:
        return 'Position your ID within the frame';
      case _ScanStep.backCard:
        return 'Keep it steady within the frame';
      case _ScanStep.selfie:
        return 'Keep your face in the center of the circle';
      default:
        return '';
    }
  }

  bool get _isSelfie => _step == _ScanStep.selfie;
  bool get _isResult =>
      _step == _ScanStep.approved || _step == _ScanStep.declined;
  bool get _isApproved => _step == _ScanStep.approved;
  bool get _isDeclined => _step == _ScanStep.declined;

  int get _activeDot {
    if (_step == _ScanStep.backCard) return 1;
    return 0;
  }

  int get _totalDots =>
      (_step == _ScanStep.frontCard || _step == _ScanStep.backCard) ? 2 : 0;

  // ── build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── live camera preview ──────────────────────────────────────────
          if (_cameraReady && _cameraController != null && !_isResult)
            _buildCameraPreview(),

          // ── dark overlay on top of preview ───────────────────────────────
          if (!_isResult) _buildOverlay(),

          // ── result screen (no camera) ────────────────────────────────────
          if (_isResult) _buildResultScreen(),

          // ── top bar ──────────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: _buildTopBar(),
          ),

          // ── flip badge (back step) ────────────────────────────────────────
          if (_step == _ScanStep.backCard)
            Positioned(
              top: MediaQuery.of(context).padding.top + 64,
              left: 0,
              right: 0,
              child: _buildFlipBadge(),
            ),

          // ── bottom HUD ────────────────────────────────────────────────────
          if (!_isResult)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomHud(),
            ),

          // ── result action buttons ────────────────────────────────────────
          if (_isDeclined)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(child: _buildRetryButton()),
            ),
        ],
      ),
    );
  }

  // ── camera preview ─────────────────────────────────────────────────────────
  Widget _buildCameraPreview() {
    return CameraPreview(_cameraController!);
  }

  // ── dark scrim with transparent hole for the frame ────────────────────────
  Widget _buildOverlay() {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;

      // Frame dimensions
      final frameW = _isSelfie ? 260.0 : 300.0;
      final frameH = _isSelfie ? 260.0 : 185.0;
      final centerY = h * 0.42;
      final centerX = w / 2;

      return CustomPaint(
        size: Size(w, h),
        painter: _OverlayPainter(
          cx: centerX,
          cy: centerY,
          frameW: frameW,
          frameH: frameH,
          isSelfie: _isSelfie,
          borderColor: _teal,
          pulseScale: _pulseAnim.value,
        ),
        child: AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, __) => const SizedBox.expand(),
        ),
      );
    });
  }

  // ── result screen (approved / declined) ───────────────────────────────────
  Widget _buildResultScreen() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      color: _darkBg,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _isApproved
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: (_isApproved
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFEF4444))
                        .withValues(alpha: 0.4),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isApproved
                        ? Icons.check_circle_outline
                        : Icons.warning_amber,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isApproved
                        ? 'ID Verified Successfully!'
                        : 'ID Verified Failed!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Frame with icon
            Container(
              width: 240,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isApproved
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFEF4444),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_isApproved
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFEF4444))
                        .withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _isApproved
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isApproved ? Icons.check : Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── top bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconBtn(Icons.close, () => Navigator.pop(context)),
          _iconBtn(
            _flashOn ? Icons.flash_on : Icons.flash_off,
            _toggleFlash,
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // ── flip badge ────────────────────────────────────────────────────────────
  Widget _buildFlipBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_teal, const Color(0xFF4A90E2)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: _teal.withValues(alpha: 0.4), blurRadius: 12),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flip_camera_android, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Flip your ID card',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // ── bottom HUD: title + dots + capture button ─────────────────────────────
  Widget _buildBottomHud() {
    String keyword = '';
    String before = '';
    String after = '';

    if (_step == _ScanStep.frontCard) {
      before = 'Align the ';
      keyword = 'FRONT';
      after = ' of your ID card';
    } else if (_step == _ScanStep.backCard) {
      before = 'Now align the ';
      keyword = 'BACK';
      after = ' of your ID card';
    } else if (_step == _ScanStep.selfie) {
      before = 'Tap ';
      keyword = 'CAPTURE';
      after = ' to begin';
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 24,
        top: 20,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)]),
              children: [
                TextSpan(text: before),
                TextSpan(
                  text: keyword,
                  style: const TextStyle(
                      color: _teal, fontWeight: FontWeight.w800),
                ),
                TextSpan(text: after),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),

          const SizedBox(height: 28),

          // Capture button
          GestureDetector(
            onTap: _capturing ? null : _capture,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                color: _capturing
                    ? Colors.white.withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.12),
                boxShadow: const [
                  BoxShadow(color: Colors.white24, blurRadius: 12),
                ],
              ),
              child: Center(
                child: _capturing
                    ? const SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Icon(Icons.camera_alt_outlined,
                        color: Colors.white, size: 32),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            _step == _ScanStep.backCard
                ? 'Tap to capture back side'
                : _step == _ScanStep.selfie
                    ? 'Tap to capture selfie'
                    : 'Tap to capture front side',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),

          if (_totalDots > 0) ...[
            const SizedBox(height: 16),
            _buildDots(),
          ],
        ],
      ),
    );
  }

  // ── retry button ──────────────────────────────────────────────────────────
  Widget _buildRetryButton() {
    return GestureDetector(
      onTap: _retry,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFFEF4444).withValues(alpha: 0.12),
        ),
        child: const Text(
          'Try Again',
          style: TextStyle(
              color: Color(0xFFEF4444),
              fontWeight: FontWeight.w600,
              fontSize: 15),
        ),
      ),
    );
  }

  // ── step dots ─────────────────────────────────────────────────────────────
  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalDots, (i) {
        final isActive = i == _activeDot;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 10 : 7,
          height: isActive ? 10 : 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? _teal : Colors.white30,
          ),
        );
      }),
    );
  }
}

// ── CustomPainter: dark overlay with transparent cutout ───────────────────────
class _OverlayPainter extends CustomPainter {
  final double cx, cy, frameW, frameH, pulseScale;
  final bool isSelfie;
  final Color borderColor;

  _OverlayPainter({
    required this.cx,
    required this.cy,
    required this.frameW,
    required this.frameH,
    required this.isSelfie,
    required this.borderColor,
    required this.pulseScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scrim = Paint()..color = Colors.black.withValues(alpha: 0.55);

    final w = frameW * pulseScale;
    final h = frameH * pulseScale;
    final left = cx - w / 2;
    final top = cy - h / 2;

    final RRect hole = isSelfie
        ? RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx, cy), width: w, height: h),
            Radius.circular(w / 2),
          )
        : RRect.fromRectAndRadius(
            Rect.fromLTWH(left, top, w, h),
            const Radius.circular(16),
          );

    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()..addRRect(hole);
    final cutout = Path.combine(PathOperation.difference, fullPath, holePath);

    canvas.drawPath(cutout, scrim);

    // glowing teal border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawRRect(hole, borderPaint);

    // crisp border on top
    final borderPaint2 = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(hole, borderPaint2);
  }

  @override
  bool shouldRepaint(_OverlayPainter old) =>
      old.pulseScale != pulseScale ||
      old.isSelfie != isSelfie ||
      old.borderColor != borderColor;
}
