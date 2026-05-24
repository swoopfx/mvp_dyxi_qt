# Word Recognition Game Design

## Overview
A QML/C++ application for children (3-10 years) to learn word recognition through visual and auditory cues.

## Components

### 1. C++ Backend (`GameEngine`)
- **Word Database**: Manages the 80-word list and random selection.
- **TTS Engine**: Interfaces with `QtTextToSpeech`.
- **Audio Recorder**: Handles recording child responses using `QAudioSource` or similar.
- **Metrics Engine**: Calculates:
    - Fluency Index
    - Accuracy
    - Vocabulary Knowledge
    - Memory Capacity
    - Progress Monitoring Index
- **API Simulator**: Handles POST requests to a dummy endpoint with JSON metrics and audio files.
- **Logger**: Records all events into a JSON list.

### 2. QML Frontend
- **Main Page**: Animated entry.
- **Game Page**:
    - Left: Colourful embossed word text.
    - Right: Image with soft bounding box.
    - Background: Soft, child-friendly.
- **Voice Flow**:
    - Load -> Wait 2s -> "Welcome Steve..." -> Wait 1s -> Read word 3x -> "What is this?" -> Record.
    - If recorded -> "I can't hear you" (comical voice).

### 3. Data Structures
#### Metrics JSON
```json
{
  "session_id": "UUID",
  "word": "Cat",
  "time_taken_ms": 1500,
  "audio_file": "rec_001.wav",
  "fluency_index": 0.85,
  "accuracy": 1.0,
  "vocabulary_knowledge": 0.9,
  "memory_capacity": 0.8,
  "progress_monitoring_index": 0.75
}
```

#### Event Log
```json
[
  {"timestamp": "...", "event": "game_start", "data": {}},
  {"timestamp": "...", "event": "word_displayed", "data": {"word": "Dog"}},
  {"timestamp": "...", "event": "audio_recorded", "data": {"file": "..."}}
]
```
