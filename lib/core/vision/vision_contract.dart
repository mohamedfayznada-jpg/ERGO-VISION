import '../models/pose_frame.dart';

abstract interface class VisionEngine {
  Future<void> initialize();
  Future<void> start();
  Future<void> stop();
  Stream<PoseFrame> get poseFrames;
  bool get isReady;
}
