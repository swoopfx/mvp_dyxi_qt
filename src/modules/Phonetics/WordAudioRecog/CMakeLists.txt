cmake_minimum_required(VERSION 3.16)

project(WordRecognitionGame VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Gui Qml Quick TextToSpeech)

qt_add_executable(WordRecognitionGame
    src/main.cpp
    src/gameengine.h
    src/gameengine.cpp
    resources.qrc
)

target_link_libraries(WordRecognitionGame PRIVATE
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::TextToSpeech
)

install(TARGETS WordRecognitionGame
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
