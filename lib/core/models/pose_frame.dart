class PoseLandmark {
  final String name;
  final double x;
  final double y;
  final double z;
  final double visibility;

  const PoseLandmark({
    required this.name,
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
  });
}

class PoseFrame {
  final int timestampMs;
  final List<PoseLandmark> landmarks;
  final double overallConfidence;

  const PoseFrame({
    required this.timestampMs,
    required this.landmarks,
    required this.overallConfidence,
  });

  PoseLandmark? landmark(String name) {
    for (final point in landmarks) {
      if (point.name == name) return point;
    }
    return null;
  }
}
