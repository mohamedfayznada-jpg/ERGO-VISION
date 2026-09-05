import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> {
  CameraController? _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('No camera available');
      final selected = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        selected,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (controller?.value.isInitialized == true)
              Center(child: CameraPreview(controller!))
            else
              const Center(child: CircularProgressIndicator()),
            const _ScanOverlay(),
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _glass('ERGO VISION'),
                  _glass('LIVE'),
                ],
              ),
            ),
            if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Camera error\n$_error', textAlign: TextAlign.center),
                ),
              ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: _BottomPanel(controllerReady: controller?.value.isInitialized == true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glass(String text) => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .58),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: .12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
        ),
      );
}

class _BottomPanel extends StatelessWidget {
  final bool controllerReady;
  const _BottomPanel({required this.controllerReady});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .72),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: .12)),
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('VISION ENGINE', style: TextStyle(fontWeight: FontWeight.w700)),
              Text(controllerReady ? 'CAMERA READY' : 'INITIALIZING', style: const TextStyle(fontSize: 11)),
            ]),
            const SizedBox(height: 12),
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('POSE', style: TextStyle(fontSize: 11)), Text('WAITING', style: TextStyle(fontSize: 11)),
            ]),
            const SizedBox(height: 7),
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('ANGLES', style: TextStyle(fontSize: 11)), Text('—', style: TextStyle(fontSize: 11)),
            ]),
            const SizedBox(height: 7),
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('RISK', style: TextStyle(fontSize: 11)), Text('—', style: TextStyle(fontSize: 11)),
            ]),
          ],
        ),
      );
}

class _ScanOverlay extends StatelessWidget {
  const _ScanOverlay();

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: CustomPaint(painter: _ScanOverlayPainter()),
      );
}

class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .35)..style = PaintingStyle.stroke..strokeWidth = 1.2;
    final box = Rect.fromCenter(center: Offset(size.width / 2, size.height * .46), width: size.width * .72, height: size.height * .62);
    canvas.drawRect(box, paint);
    final cross = Paint()..color = Colors.white.withValues(alpha: .22)..strokeWidth = 1;
    final c = box.center;
    canvas.drawLine(Offset(c.dx - 18, c.dy), Offset(c.dx + 18, c.dy), cross);
    canvas.drawLine(Offset(c.dx, c.dy - 18), Offset(c.dx, c.dy + 18), cross);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
