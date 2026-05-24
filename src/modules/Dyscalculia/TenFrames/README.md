# Ten-Frame Number Bonds Game

A highly graphical and animated educational game built with Qt QML and C++ to help children understand number bonds up to 10 and place value.

## Features

- **Animated Ten-Frame Board:** Visual representation of numbers 1-10.
- **Physical Counters:** Drag-and-drop red and blue counters.
- **Difficulty Levels:** Easy (1-5) and Hard (1-9) modes.
- **Real-time Metrics:** Tracks accuracy, mental math speed, and concentration.
- **Data Logging:** Every interaction is logged into a JSON object for analysis.
- **Evaluation Indices:**
  - **Number Sense Index:** Measures intuitive number understanding.
  - **Mental Math Speed Index:** Response rate relative to question initiation.
  - **Concentration Index:** Calculated based on response consistency.

## Project Structure

- `src/`: C++ backend and QML frontend source files.
- `assets/`: Graphical (PNG) and Audio (WAV) assets.
- `CMakeLists.txt`: Build configuration.
- `architecture_design.md`: Detailed architectural overview.

## How to Build

### Prerequisites
- Qt 6.x (Gui, Qml, Quick, Multimedia modules)
- CMake 3.16+
- C++17 Compiler

### Build Steps
1. Create a build directory: `mkdir build && cd build`
2. Run CMake: `cmake ..`
3. Compile: `make` (or use your IDE's build button)
4. Run the executable: `./TenFrameGame`

## Metrics and Data Logging

The game logs events like `question_asked` and `answer_submitted`. At the end of a session, you can export the data to a JSON file.

### Example JSON Event
```json
{
    "event_type": "answer_submitted",
    "data": {
        "success": true,
        "placed_value": 3,
        "answered_at": "2026-05-10T14:35:00Z"
    },
    "relative_time_ms": 1250,
    "timestamp": "2026-05-10T14:35:00Z"
}
```

## Assets
All graphical and audio assets are included in the `assets/` folder.
- `assets/images/`: Counters, grid, and background.
- `assets/audio/`: Background music and sound effects.
