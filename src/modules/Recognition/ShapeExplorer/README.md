# Shape Explorer: QML Educational Game

## Overview
Shape Explorer is a graphical shape matching and recognition game designed for children. It features:
- **2D Depth Illusion**: Shapes have glossy finishes and drop shadows for a tactile feel.
- **Animations**: Smooth scaling and opacity transitions for feedback.
- **Interactive Character**: A rabbit that appears periodically, linked to advanced telemetry.
- **Audio Feedback**: Custom sound effects for success, failure, and character events.

## Telemetry & Metrics
The game tracks comprehensive data points outputted as a JSON object:
- **Basic Stats**: Total game time, tries, correct/failed matches.
- **Averages**: Average time for correct and failed matches.
- **Input Tracking**: 
    - Press duration and location.
    - Motion direction (Up, Down, Left, Right).
    - Rabbit visibility correlation (did the user press while the rabbit was visible?).
- **Calculated Indices**:
    - **Creative Index**: Based on the variety of motion patterns.
    - **Problem Solving Index**: A weighted score combining accuracy and speed.

## How to Run
1. Ensure you have Qt 5.15+ installed.
2. Run using `qmlscene Main.qml` or include in a Qt project.
3. Click "Finish Game" to output the JSON metrics to the console.
