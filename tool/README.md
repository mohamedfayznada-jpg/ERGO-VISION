# Local build

This repository contains the product/domain source. Flutter platform folders are generated with the Flutter CLI to keep them aligned with the installed Flutter SDK.

```bash
flutter create . --platforms=android,ios
flutter pub get
flutter run
```

The next native integration step adds MediaPipe Pose Landmarker to Android and iOS. Google's current documentation uses `com.google.mediapipe:tasks-vision` on Android and `MediaPipeTasksVision` on iOS, with a compatible `.task` model bundled with the app. Pose Landmarker supports live-stream mode and returns image and 3D world landmarks.

Do not commit generated signing credentials or machine-specific files.
