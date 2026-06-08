# Qt6 / QML Kids Word Recognition Game

A gorgeous, highly optimized lightweight Word Recognition Game written in **Qt6 QML** with a **C++ backend controller** designed specifically for kids ages 3-10 years old.

## Features
- **Slow, Precise Pronunciation Engine**: Uses `QtTextToSpeech` to sound and spell words, highlighting individual characters as they are read.
- **Microphone Capture & Record**: Employs Qt's `QAudioSource` configuring audio at 16000Hz mono mono recording for pocket-first Speech-to-Text inference models like `Whisper.cpp` or local micro services.
- **Simulated Metrics Framework**: Heavy statistical calculation processed asynchronously on C++ background threads to return **Accuracy**, **Fluency**, **Vocabulary knowledge** and **Memory Capacity** as QML models.
- **Comical voice reprompts**: Squeaks funny speech prompts to entice children on silent intervals.

## Build Requirements
- **Qt SDK**: Qt 6.0 or superior with `Quick`, `Qml`, `Multimedia`, `TextToSpeech` and `Network` components.
- **C++ Compiler**: Compatible with C++17 compilers (GCC 9+, Clang 11+, or MSVC 2019+).
- **CMake**: CMake 3.16+ is used as the unified build mechanism.

## Step-by-Step Compile instructions
1. Open Qt Creator.
2. Select "Open Project" and choose the `CMakeLists.txt` file in this directory.
3. Configure your kit selection (Choose Qt 6.x for Desktop or Android platform SDKs).
4. Run "Build & Run" (`Ctrl+R` or click the green Play icon).
5. The kids game launches with full audio synthesis on any host OS!
