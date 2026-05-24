# Sum Swamp Game Specification

## Game Mechanics
- **Objective**: Be the first player to reach the "Finish" space.
- **Components**: 
    - 2 Number Dice (0-6 or 1-6)
    - 1 Operation Die (+ and -)
    - Game Board with spaces: Numbers (1-6), Even/Odd spaces, Shortcuts (Crocodile, Log), and the "Endless Loop".
- **Turn Sequence**:
    1. Roll all three dice (e.g., 5, +, 2).
    2. Solve the equation (5 + 2 = 7).
    3. Move the game piece forward by the result.
    4. If the result is negative (e.g., 2 - 5), the absolute value or 0 might be used depending on difficulty.
- **Special Spaces**:
    - **Number Spaces**: If you land on a number (e.g., 3), roll the operation die and one number die. If you roll "3 + 2", move 5. (Wait, standard rules say if you land on a number, you roll again? Actually, some versions say you roll the operation die and one number die to move further).
    - **Even/Odd Spaces**: Roll one number die. If it matches the space (e.g., land on "Even" and roll a 4), move forward that many spaces.
    - **Shortcuts**: Crocodile and Log shortcuts allow skipping ahead.
    - **Endless Loop**: Must land on the "Exit" space to leave; otherwise, keep circling.

## Difficulty Levels
1. **Tadpole (Easy)**: 
    - Numbers 0-5.
    - Addition only.
    - Visual aids for counting.
2. **Frog (Medium)**: 
    - Numbers 1-6.
    - Addition and Subtraction.
    - Standard rules.
3. **Gator (Hard)**:
    - Numbers 1-12 (using larger dice).
    - Addition, Subtraction, and maybe simple Multiplication/Comparison.
    - Faster timer.

## Metrics to Track
- **Number Sense**: Ability to subitize (recognize dice patterns) and understand magnitude.
- **Mental Math Speed**: Time from dice roll to correct answer input.
- **Accuracy**: (Correct Answers / Total Attempts) * 100.
- **Concentration**: Consistency in response time; tracking distractions (long pauses).
- **Error Evaluation**: Categorizing mistakes (e.g., sign errors, calculation off-by-one, etc.).
- **Frequency**: Number of games played per session.

## Data Format (JSON)
```json
{
  "session_id": "uuid",
  "timestamp": "iso-date",
  "events": [
    {
      "type": "roll",
      "dice": [5, "+", 2],
      "correct_answer": 7,
      "user_answer": 7,
      "time_taken": 1.2,
      "difficulty": "Frog"
    }
  ],
  "metrics": {
    "average_speed": 1.5,
    "accuracy": 0.95,
    "error_types": { "off_by_one": 1 }
  }
}
```
