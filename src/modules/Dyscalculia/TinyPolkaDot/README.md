# Tiny Polka Dot - Educational Game

A highly graphical and animated educational game for children built with Qt/QML and C++.

## Features
- **Engaging Gameplay**: Matching dots and numbers based on the Tiny Polka Dot card game.
- **Difficulty Levels**: Easy (0-5), Medium (0-8), and Hard (0-10).
- **Comprehensive Metrics**: Tracks number sense, mental math speed, accuracy, concentration, and more.
- **JSON Logging**: Every activity event is logged in a structured JSON format.
- **Beautiful Assets**: Includes custom-generated background and upbeat music.

## Technical Details
- **Frontend**: QML for UI and animations.
- **Backend**: Qt C++ for heavy computation, logic processing, and metric calculation.
- **Metrics Tracked**:
    - Number Sense (Correct matches)
    - Mental Math Speed (Average time to solve)
    - Accuracy (Correct vs. Failed attempts)
    - Concentration (Consistency in action intervals)
    - Frequency (Activity timestamps)

## How to Run
1. Ensure Qt 6.2+ is installed with Quick and Multimedia modules.
2. Open `CMakeLists.txt` in Qt Creator or run:
   ```bash
   mkdir build && cd build
   cmake ..
   make
   ./appTinyPolkaDot
   ```

## Assets
- `background.png`: Playful background image.
- `background_music.mp3`: Cheerful background track.
- `session_data.json`: Generated after each session with full metrics and activity logs.
