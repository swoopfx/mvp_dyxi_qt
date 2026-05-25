cmake_minimum_required(VERSION 3.16)

# project(TenFrameGame VERSION 0.1 LANGUAGES CXX)

# set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_STANDARD_REQUIRED ON)

# find_package(Qt6 REQUIRED COMPONENTS Gui Qml Quick Multimedia)

# qt_standard_project_setup()

qt_add_qml_module(TenFrames
    STATIC
    URI Dyscalculia.TenFrames
    RESOURCE_PREFIX "/modules/dyscalculia/tenframegame"
    QML_FILES TenFramesMain.qml
    QML_FILES TenFrameBoard.qml
    QML_FILES Counter.qml

    SOURCES gameenginex.h gameenginex.cpp
    SOURCES metricsengine.h metricsengine.cpp
    SOURCES sessionlogger.h sessionlogger.cpp



)

qt_add_resources(TenFrames
    "tenframegame_assets"
     PREFIX "/tenframegame"
     FILES assets/audio/background_music.wav
     FILES assets/audio/failure.wav
     FILES assets/audio/success.wav

     FILES assets/images/blue_counter.png
     FILES assets/images/blue_counter_original.png
     FILES assets/images/game_background.png
     FILES assets/images/red_counter.png
     FILES assets/images/red_counter_original.png
     FILES assets/images/ten_frame_grid.png
     FILES assets/images/ten_frame_grid_original.png
)

# target_link_libraries(TenFrameGame PRIVATE
#     Qt6::Gui
#     Qt6::Qml
#     Qt6::Quick
#     Qt6::Multimedia
# )

# include(GNUInstallDirs)
# install(TARGETS TenFrameGame
#     BUNDLE DESTINATION .
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
# )
