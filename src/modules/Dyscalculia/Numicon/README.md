# Numicon Adventure: Educational Game for Children

A highly graphical, animated, and engaging Numicon game built with **Qt/QML** and **Qt C++**. Designed to help children develop number sense, mental math speed, and concentration through interactive play.

## Features
- **Highly Graphical:** 3D rendered Numicon tiles and whimsical backgrounds.
- **Animated UI:** Smooth transitions, floating tiles, and interactive feedback.
- **Difficulty Levels:**
  - **Level 1:** Number recognition and matching.
  - **Level 2:** Addition and "one more than" challenges.
  - **Level 3:** Number bonds to 10 and subtraction.
- **Metric Tracking:** Real-time calculation of accuracy, speed, and concentration.
- **JSON Logging:** Every event is logged in a JSON format for educational progress evaluation.
- **Audio Assets:** Playful background music and rewarding sound effects.

## Project Structure
- `src/backend/`: Qt C++ classes for game logic and metrics.
- `src/qml/`: QML files for the user interface and animations.
- `assets/images/`: High-resolution graphical assets.
- `assets/audio/`: Whimsical audio assets.

## Build Instructions
1. **Prerequisites:**
   - Qt 5.15 or Qt 6.x
   - C++17 compatible compiler (GCC/Clang/MSVC)
2. **Steps:**
   - Open the project in **Qt Creator**.
   - Configure the project with your preferred Kit.
   - Build and Run.

## Metrics & Data
The game tracks:
- **Number Sense:** Correctness of shape-to-value association.
- **Mental Math Speed:** Average time per correct answer.
- **Accuracy:** Success rate across all attempts.
- **Concentration:** Calculated based on response time consistency.
- **Activity Log:** Viewable within the app or exported as `numicon_activity_log.json`.

## Task Complementing Metrics
To enhance learning, the game provides varied tasks within each difficulty level:
- **Matching:** Visual to digit recognition.
- **Arithmetic:** Building foundations for mental calculation.
- **Logical Gaps:** Identifying "one more" or "missing piece" to build 10.
