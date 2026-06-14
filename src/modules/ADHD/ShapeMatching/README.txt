📋 ASTRO SHAPE COGNITIVE TEST BUNDLE (QT C++ & MULTI-AGE QML PROJECT)
========================================================================

Welcome to the production-ready Qt Quick project directory. This structure offloads calculation, tracking, and analytics to a C++ engine, leaving QML purely for fluid UI presentation.

📁 BUNDLE DIRECTORY MAP:
├── CMakeLists.txt            - Modern CMake compilation script for Qt 5 and Qt 6.
├── main.cpp                  - Application entry point registering the C++ backend.
├── telemetrybackend.h        - C++ header defining properties, signals, and stats equations.
├── telemetrybackend.cpp      - C++ implementation calculating speeds, logs, and derived index metrics.
├── Main.qml                  - Primary UI shell container displaying header HUD and index cards.
├── EasyPage.qml              - Large tolerance page layout for ages 4-6 (3 shapes, static sockets).
├── MediumPage.qml             - Default page layout for ages 7-9 (5 shapes).
├── HardPage.qml              - High difficulty page layout with slow vertical drifting target sockets.
├── ShapeItem.qml             - Draggable shape card with dynamic rendering.
├── qml.qrc                   - Qt XML resource package listing all virtual files.
├── ADHD_CLINICAL_TELEMETRY.txt - Detailed analysis of the metrics, formulation, and application for ADHD support.
└── assets/                   
    ├── cloud.svg             - Pure vector cloud coordinate asset.
    └── audio/
        ├── select.wav        - Synthetic micro bubble sound, used for selection.
        ├── correct.wav       - High register ascending chord.
        ├── fail.wav          - Low register buzzing sound.
        └── rabbit.wav        - Squeaking audio asset.

🚀 COMPILING AND RUNNING THE GAME:

Option A: Qt Creator IDE (Easiest)
1. Install Qt 5.15 or Qt 6.x with Qt Multimedia modules.
2. Open Qt Creator, click "Open Project", select "CMakeLists.txt".
3. Configure the project with your active desk kit (Desktop Qt).
4. Click "Run" (Green Arrow) to build and launch!

Option B: Console Compilation (Command Line)
1. Navigate inside this directory:
   cd ChildShapeMatcher
2. Create and go to a build folder:
   mkdir build && cd build
3. Run CMake configuration:
   cmake ..
4. Build the project:
   cmake --build .
5. Launch the generated executable:
   ./ChildShapeMatcher
