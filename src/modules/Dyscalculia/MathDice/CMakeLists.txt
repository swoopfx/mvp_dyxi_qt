cmake_minimum_required(VERSION 3.16)

project(MathDice VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Gui Core)

qt_add_executable(MathDice
    src/cpp/main.cpp
    src/cpp/gameengine.h
    src/cpp/gameengine.cpp
)

qt_add_qml_module(MathDice
    URI MathDice
    VERSION 1.0
    QML_FILES 
        src/qml/Main.qml
        src/qml/AnimatedDice.qml
        src/qml/MetricsDashboard.qml
        src/qml/MetricRow.qml
)

target_link_libraries(MathDice PRIVATE Qt6::Quick Qt6::Gui Qt6::Core)

install(TARGETS MathDice
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
