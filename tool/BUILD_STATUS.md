# Build status

Implemented in the feature branch:

- Flutter app foundation
- Home navigation to Live Scan
- Real camera preview using the official Flutter camera plugin
- Platform-neutral PoseFrame contract
- Native vision MethodChannel contract
- Geometry and biomechanics calculation foundation
- Temporal motion engine foundation
- Configurable ergonomic risk indicator foundation

Integration gate still required on a real device:

1. Generate Android/iOS platform folders with the installed Flutter SDK.
2. Add the current MediaPipe Pose Landmarker native SDKs.
3. Bundle a compatible Pose Landmarker `.task` model.
4. Validate camera frame format/orientation and timestamp handling.
5. Run on physical Android and iOS devices and measure latency/FPS.

The app must not report pose or ergonomic measurements when required landmarks are unavailable or below confidence threshold.
