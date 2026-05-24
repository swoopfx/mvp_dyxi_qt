cmake_minimum_required(VERSION 3.16)

project(NumiconGame VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia)

set(PROJECT_SOURCES
    src/main.cpp
    src/backend/GameEngine.h
    src/backend/MetricsTracker.h
    src/backend/ActivityLogger.h
    src/qml/MainView.qml
    src/qml/NumiconTile.qml
    src/qml/MetricItem.qml
    src/qml/LogViewer.qml
)

qt_add_executable(NumiconGame
    ${PROJECT_SOURCES}
)

qt_add_resources(NumiconGame "assets"
    PREFIX "/"
    FILES
        assets/images/numicon_1.png
        assets/images/numicon_2.png
        assets/images/numicon_3.png
        assets/images/numicon_4.png
        assets/images/numicon_5.png
        assets/images/numicon_6.png
        assets/images/numicon_7.png
        assets/images/numicon_8.png
        assets/images/numicon_9.png
        assets/images/numicon_10.png
        assets/images/game_background.jpg
        assets/audio/background_music.mp3
        assets/audio/correct.wav
        assets/audio/error.wav
)

target_link_libraries(NumiconGame PRIVATE Qt6::Quick Qt6::Multimedia)

include(GNUInstallDirs)
install(TARGETS NumiconGame
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
