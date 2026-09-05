import '../math/geometry.dart';
import '../models/pose_frame.dart';

class BiomechanicsMetrics {
  final double? leftElbow;
  final double? rightElbow;
  final double? leftKnee;
  final double? rightKnee;
  final double? trunkAngle;

  const BiomechanicsMetrics({
    this.leftElbow,
    this.rightElbow,
    this.leftKnee,
    this.rightKnee,
    this.trunkAngle,
  });
}

class BiomechanicsEngine {
  BiomechanicsMetrics analyze(PoseFrame frame) {
    PoseLandmark? p(String name) => frame.landmark(name);

    double? angle(String a, String v, String c) {
      final first = p(a);
      final vertex = p(v);
      final third = p(c);
      if (first == null || vertex == null || third == null) return null;
      if (first.visibility < .4 || vertex.visibility < .4 || third.visibility < .4) return null;
      final value = Geometry.angleDegrees(first, vertex, third);
      return value.isNaN ? null : value;
    }

    final leftShoulder = p('left_shoulder');
    final rightShoulder = p('right_shoulder');
    final leftHip = p('left_hip');
    final rightHip = p('right_hip');
    double? trunk;
    if (leftShoulder != null && rightShoulder != null && leftHip != null && rightHip != null) {
      final shoulder = PoseLandmark(
        name: 'shoulder_center',
        x: (leftShoulder.x + rightShoulder.x) / 2,
        y: (leftShoulder.y + rightShoulder.y) / 2,
        z: (leftShoulder.z + rightShoulder.z) / 2,
        visibility: (leftShoulder.visibility + rightShoulder.visibility) / 2,
      );
      final hip = PoseLandmark(
        name: 'hip_center',
        x: (leftHip.x + rightHip.x) / 2,
        y: (leftHip.y + rightHip.y) / 2,
        z: (leftHip.z + rightHip.z) / 2,
        visibility: (leftHip.visibility + rightHip.visibility) / 2,
      );
      // Relative to the camera/image vertical axis. This is a neutral trunk
      // orientation proxy; a calibrated 3D reference can replace it later.
      final vertical = PoseLandmark(
        name: 'vertical_reference',
        x: hip.x,
        y: hip.y - 1,
        z: hip.z,
        visibility: 1,
      );
      trunk = Geometry.angleDegrees(vertical, hip, shoulder);
    }

    return BiomechanicsMetrics(
      leftElbow: angle('left_shoulder', 'left_elbow', 'left_wrist'),
      rightElbow: angle('right_shoulder', 'right_elbow', 'right_wrist'),
      leftKnee: angle('left_hip', 'left_knee', 'left_ankle'),
      rightKnee: angle('right_hip', 'right_knee', 'right_ankle'),
      trunkAngle: trunk,
    );
  }
}
