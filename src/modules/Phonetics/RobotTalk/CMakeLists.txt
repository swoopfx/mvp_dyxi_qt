cmake_minimum_required(VERSION 3.16)

project(RobotTalkGame VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Gui Qml Quick TextToSpeech Network)

qt_add_executable(RobotTalkGame
    src/main.cpp
    src/gameengine.cpp
    src/gameengine.h
)

qt_add_qml_module(RobotTalkGame
    URI RobotGame
    VERSION 1.0
    QML_FILES qml/main.qml
)

target_link_libraries(RobotTalkGame PRIVATE 
    Qt6::Gui 
    Qt6::Qml 
    Qt6::Quick 
    Qt6::TextToSpeech
    Qt6::Network
)

install(TARGETS RobotTalkGame
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
