# ERGO VISION V1 — Analysis Specification

## Goal
Build a mobile-first real-time ergonomic vision analyzer for Android and iOS. The first product loop is camera -> pose landmarks -> biomechanics -> temporal motion analysis -> ergonomic indicators -> visual overlay.

## Measurement model
All measurements must retain source, timestamp, confidence and coordinate-space metadata. The system must distinguish observed vision measurements from ergonomic interpretation.

### Core landmarks
Head/face proxy, shoulders, elbows, wrists, hips, knees and ankles. Use the pose model's canonical landmark indices through an adapter; never scatter model-specific indices through the app.

### Derived metrics
- Neck flexion proxy
- Trunk flexion proxy
- Left/right shoulder elevation proxy
- Left/right elbow angle
- Left/right wrist angle where visibility permits
- Left/right knee angle
- Joint trajectories
- Angular velocity
- Exposure duration by posture band
- Repetition candidates
- Measurement confidence

## Temporal engine
Use a timestamped rolling window. Smooth noisy landmarks before derivative calculations. Detect posture state transitions with hysteresis to avoid flicker. Repetition detection must require a complete movement cycle rather than counting every threshold crossing.

## Risk engine
V1 produces ergonomic risk indicators, not medical diagnoses. Risk logic must be configurable and versioned. Every risk indicator must retain the measurements and thresholds that caused it so the UI can explain the result.

## Visualization
The live screen should render:
- Camera preview
- Skeleton connections
- Joint markers
- Selected angle arcs/labels
- Motion trails for selected joints
- Risk highlighting by body region
- Overall state
- Confidence
- Compact expandable measurement panel

## Architecture boundary
Flutter owns navigation, UI, state and visualization orchestration. Native Android/iOS owns camera and pose inference integration where required. A platform-neutral domain layer consumes normalized PoseFrame objects and performs biomechanics, temporal analysis and ergonomic rules.

## Safety and accuracy
Never present a pose estimate as a medical diagnosis. Show low-confidence states explicitly. If a required landmark is occluded or below confidence threshold, mark the derived measurement unavailable rather than fabricating a value.
