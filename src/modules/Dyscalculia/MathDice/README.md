# Math Dice Adventure - QML/Qt C++ Game

## Overview
An engaging, highly graphical math game for children designed to improve mental arithmetic and focus.

## Features
- **Dynamic Difficulty**: Easy (Addition/Subtraction), Medium (Multiplication), Hard (Complex expressions).
- **Advanced Metrics**: Tracks accuracy, concentration (response time consistency), and frequency.
- **JSON Logging**: Every game event is logged for educational evaluation.
- **Focus Sprint**: A complementary task to enhance concentration.
- **Animated UI**: Rich QML animations and colorful assets.

## Project Structure
- `src/cpp/`: Core game logic and metrics engine in C++.
- `src/qml/`: Interactive UI components.
- `assets/`: High-quality images and audio.
- `logs/`: Session data in JSON format.

## How to Build
1. Install Qt 6.x and CMake.
2. Open the project in Qt Creator or use the command line:
   ```bash
   mkdir build && cd build
   cmake ..
   make
   ```
3. Run the executable `MathDice`.

## Metrics Calculation
- **Accuracy**: Correct / Total Attempts.
- **Concentration**: Measured by the inverse of response time variance.
- **Frequency**: Attempts per minute.
- **Error Evaluation**: Logged in `game_log.json` for review.
