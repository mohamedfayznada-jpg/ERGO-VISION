import 'dart:math' as math;
import '../models/pose_frame.dart';

class Geometry {
  static double distance(PoseLandmark a, PoseLandmark b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    final dz = a.z - b.z;
    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }

  static double angleDegrees(
    PoseLandmark a,
    PoseLandmark vertex,
    PoseLandmark c,
  ) {
    final ax = a.x - vertex.x;
    final ay = a.y - vertex.y;
    final az = a.z - vertex.z;
    final cx = c.x - vertex.x;
    final cy = c.y - vertex.y;
    final cz = c.z - vertex.z;

    final dot = ax * cx + ay * cy + az * cz;
    final aNorm = math.sqrt(ax * ax + ay * ay + az * az);
    final cNorm = math.sqrt(cx * cx + cy * cy + cz * cz);
    if (aNorm == 0 || cNorm == 0) return double.nan;

    final cosine = (dot / (aNorm * cNorm)).clamp(-1.0, 1.0);
    return math.acos(cosine) * 180 / math.pi;
  }
}
