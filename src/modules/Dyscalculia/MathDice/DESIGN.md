# Math Dice Game Design Document

## 1. Game Concept
A digital version of the "Math Dice" game where players use scoring dice (1-6) and mathematical operators to reach a target number (1-12 or 1-24).

## 2. Technical Stack
- **Frontend**: QML (Qt Quick) for UI, animations, and graphics.
- **Backend**: Qt C++ for game logic, metrics calculation, and JSON logging.
- **Data Format**: JSON for logging and asset metadata.

## 3. Architecture
### C++ Classes
- `GameEngine`: 
    - Manages game state (Target, Scoring Dice, Current Equation).
    - Validates equations.
    - Difficulty levels:
        - **Easy**: Target (1-12), 3 scoring dice, only `+` and `-`.
        - **Medium**: Target (1-20), 4 scoring dice, `+`, `-`, `*`.
        - **Hard**: Target (1-50), 5 scoring dice, `+`, `-`, `*`, `/`, `()`.
- `MetricsManager`:
    - `accuracy`: `Correct / Total Attempts`.
    - `concentration`: `1 / (Standard Deviation of response time)`. High consistency means high concentration.
    - `frequency`: `Attempts / Minute`.
    - `error_evaluation`: Categorizes errors into `CALCULATION_ERROR`, `OPERATOR_MISUSE`, `TARGET_MISMATCH`.
- `JsonLogger`:
    - Saves every `Event` (Roll, Submit, LevelChange) with a timestamp.

### QML Components
- `Main.qml`: Root window and state management.
- `Dice.qml`: Animated 3D-like dice component.
- `OperatorButton.qml`: Styled buttons for `+`, `-`, etc.
- `MetricsDashboard.qml`: Visual representation of player stats.

## 4. Assets
- **Graphics**: 
    - Dice faces (PNG/SVG).
    - Backgrounds (Bright, playful gradients).
    - UI Icons (Reset, Help, Stats).
- **Audio**:
    - `roll.wav`: Dice rolling sound.
    - `success.wav`: Correct answer chime.
    - `fail.wav`: Error sound.

## 5. JSON Schema for Logs
```json
{
  "session_id": "UUID",
  "events": [
    {
      "timestamp": "ISO8601",
      "type": "SUBMIT",
      "data": {
        "equation": "3 + 4",
        "result": 7,
        "target": 12,
        "is_correct": false,
        "time_taken": 5.4
      }
    }
  ]
}
```

## 6. Complementary Task
**"The Focus Sprint"**: A task where the user must solve 5 problems in a row without any errors. This directly impacts the `concentration` and `accuracy` metrics.
