import '../math/geometry.dart';
import '../models/pose_frame.dart';

class MotionSample {
  final int timestampMs;
  final String landmark;
  final double speed;

  const MotionSample({required this.timestampMs, required this.landmark, required this.speed});
}

class MotionEngine {
  final List<PoseFrame> _frames = [];
  final int windowMs;

  MotionEngine({this.windowMs = 2000});

  void addFrame(PoseFrame frame) {
    _frames.add(frame);
    final cutoff = frame.timestampMs - windowMs;
    _frames.removeWhere((item) => item.timestampMs < cutoff);
  }

  MotionSample? speedOf(String landmarkName) {
    if (_frames.length < 2) return null;
    final previous = _frames[_frames.length - 2];
    final current = _frames.last;
    final a = previous.landmark(landmarkName);
    final b = current.landmark(landmarkName);
    if (a == null || b == null) return null;
    if (a.visibility < .4 || b.visibility < .4) return null;
    final dt = (current.timestampMs - previous.timestampMs) / 1000;
    if (dt <= 0) return null;
    return MotionSample(
      timestampMs: current.timestampMs,
      landmark: landmarkName,
      speed: Geometry.distance(a, b) / dt,
    );
  }

  List<PoseFrame> get frames => List.unmodifiable(_frames);
}
