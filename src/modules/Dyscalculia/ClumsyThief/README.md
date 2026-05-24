# Clumsy Thief - QML/C++ Edition

## Project Overview
This is a highly graphical and animated implementation of the "Clumsy Thief" card game, designed for children to enhance their mental math skills.

## Features
- **Animated UI**: Smooth card transitions and hover effects using QML.
- **C++ Backend**: High-performance game logic and metric tracking.
- **Metric Tracking**: Real-time calculation of accuracy, speed, and number sense.
- **JSON Logging**: Every game event is logged for educational analysis.
- **Difficulty Levels**:
    - **Easy**: Target sum of 20.
    - **Hard**: Target sum of 100.

## Assets Included
- `assets/card_back.png`: Playful thief character.
- `assets/money_card_10.png`: Brightly colored money card.
- `assets/thief_card.png`: Expressive thief character.
- `assets/jail_card.png`: Bold red jail card.
- `assets/game_background.png`: Cozy room setting.
- `assets/game_music.wav`: Upbeat background track.
- `assets/success_sfx.wav`: Encouraging voice-over.

## How to Run
1. Install Qt 5.15 or later.
2. Open the project in Qt Creator.
3. Build and run.

## Metrics JSON Format
The game exports a `metrics.json` file in the `data/` directory with the following structure:
```json
{
  "events": [...],
  "summary": {
    "correct": 10,
    "failed": 2,
    "accuracy": 0.83
  }
}
```
