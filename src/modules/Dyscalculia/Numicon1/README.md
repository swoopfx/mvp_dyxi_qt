# Numicon Adventure Game

A highly graphical and animated educational game for children to learn number sense using the Numicon system.

## Features
- **Multi-level Difficulty**:
  - Level 1: Number Recognition
  - Level 2: Basic Addition (Number Bonds)
  - Level 3: Mental Math Speed Challenges
- **Comprehensive Metrics**: Tracks accuracy, speed, concentration, and error patterns.
- **JSON Logging**: Every event is logged for educational analysis.
- **Rich Assets**: Custom-generated 3D-style Numicon shapes and playful audio.

## Project Structure
- `main.qml`: Main UI and game logic.
- `NumiconShape.qml`: Reusable animated Numicon component.
- `gameengine.cpp/h`: C++ logic for task generation and answer checking.
- `metrictracker.cpp/h`: C++ backend for metric calculation and JSON logging.
- `assets/`: Images and audio files.

## How to Build
1. Install Qt 5.15 or Qt 6.
2. Open `numicon_game.pro` in Qt Creator.
3. Build and Run.

## Metrics Tracked
The game calculates:
- **Number Sense**: Accuracy in identifying shapes.
- **Mental Math Speed**: Average time per correct answer.
- **Concentration**: Consistency of response times.
- **Error Evaluation**: Logs specific incorrect inputs for pattern analysis.

## Data Export
Activity logs are saved in JSON format, making it easy to integrate with other educational tools.
