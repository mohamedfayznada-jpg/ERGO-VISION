import 'dart:async';
import 'package:flutter/services.dart';
import '../models/pose_frame.dart';
import 'vision_contract.dart';

class MethodChannelVisionEngine implements VisionEngine {
  static const _channel = MethodChannel('ergo_vision/vision');
  final _controller = StreamController<PoseFrame>.broadcast();
  bool _ready = false;

  MethodChannelVisionEngine() {
    _channel.setMethodCallHandler(_handleNativeEvent);
  }

  Future<void> _handleNativeEvent(MethodCall call) async {
    if (call.method != 'poseFrame') return;
    final data = Map<String, dynamic>.from(call.arguments as Map);
    final raw = (data['landmarks'] as List<dynamic>? ?? const []);
    final landmarks = raw.map((item) {
      final point = Map<String, dynamic>.from(item as Map);
      return PoseLandmark(
        name: point['name'] as String,
        x: (point['x'] as num).toDouble(),
        y: (point['y'] as num).toDouble(),
        z: (point['z'] as num).toDouble(),
        visibility: (point['visibility'] as num).toDouble(),
      );
    }).toList(growable: false);
    _controller.add(PoseFrame(
      timestampMs: (data['timestampMs'] as num).toInt(),
      landmarks: landmarks,
      overallConfidence: (data['confidence'] as num?)?.toDouble() ?? 0,
    ));
  }

  @override
  Future<void> initialize() async {
    await _channel.invokeMethod('initialize');
    _ready = true;
  }

  @override
  Future<void> start() => _channel.invokeMethod('start');

  @override
  Future<void> stop() => _channel.invokeMethod('stop');

  @override
  Stream<PoseFrame> get poseFrames => _controller.stream;

  @override
  bool get isReady => _ready;

  Future<void> dispose() async {
    await _controller.close();
  }
}
