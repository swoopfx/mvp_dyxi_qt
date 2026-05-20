# Game Design Plan: Shape Explorer

## 1. Visual Style & Assets
- **Theme**: Bright, colorful, "Comical" (as per system knowledge for children's apps).
- **Shapes**: Circle, Square, Triangle, Star, Hexagon.
    - *2D Depth Illusion*: Each shape will have a main color, a darker side-shading, and a drop shadow.
- **Character**: An animated Rabbit that appears randomly to provide feedback or as part of the "visibility" metric.
- **Background**: Soft pastel landscape.
- **Audio**:
    - `success.wav`: High-pitched chime.
    - `failure.wav`: Soft "boing" or low-pitched pop.
    - `select.wav`: Click sound.
    - `rabbit_appear.wav`: Magic sparkle sound.

## 2. Telemetry System
The telemetry will be managed by a singleton or a dedicated object.
### Metrics tracked:
- **Game Level**: `total_game_time`, `total_correct`, `total_failed`, `total_tries`.
- **Match Events**: List of `{shape_id, status, select_to_match_duration, total_duration}`.
- **Input Events**: List of `{press_time, press_duration, motion_direction, rabbit_visible_at_press, rabbit_visibility_duration, press_vs_visibility_ratio}`.
- **Calculated Indices**:
    - `Creative Index`: Ratio of unique interaction paths vs total interactions.
    - `Problem Solving Index`: (Correct Matches / Total Tries) * (1 / Average Time per Correct Match).

## 3. QML Structure
- `Main.qml`: Main window and state machine.
- `Shape.qml`: Base component for draggable shapes.
- `TargetSlot.qml`: Where shapes are dropped.
- `Rabbit.qml`: Animated character with visibility timer.
- `Telemetry.js`: Logic for data aggregation and JSON export.
