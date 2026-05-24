# Robot Talk Game

An interactive, multisensory game designed for children to practice phoneme blending and segmenting sounds.

## Features
- **Interactive Animal Characters**: Randomly selected animal (Hermit Crab, Cat, Dog) that animates when talking.
- **Phoneme Blending**: The robot speaks words in broken sounds (e.g., /c/ - /a/ - /t/).
- **Multisensory Feedback**: Colorful, embossed word display and slow, precise text-to-speech.
- **Metrics Collection**: Tracks fluency, accuracy, vocabulary knowledge, and memory capacity.
- **API Integration**: Simulates POSTing metrics and audio files to a backend endpoint.

## Project Structure
- `src/`: C++ backend logic (GameEngine).
- `qml/`: User interface components.
- `assets/`: Image assets for animals.

## Technical Details
- **Framework**: Qt 6 (QML & C++)
- **TTS**: QtTextToSpeech
- **Networking**: QNetworkAccessManager for API simulation.
- **Data Format**: JSON for metrics and events.

## How to Run
1. Ensure Qt 6 and CMake are installed.
2. Build the project using CMake.
3. Run the `RobotTalkGame` executable.
