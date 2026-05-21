 
project(Recognition VERSION 0.1 LANGUAGES CXX)
# set_source_files_properties(resources)

# add_library(${PROJECT_NAME}lib STATIC)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia QuickControls2  Network Core)

# qt_add_executable()

qt_add_qml_module(
    Recognition
    STATIC
    URI Recognition
    RESOURCE_PREFIX "/recognition"
    QML_FILES
       ShapeExplorer/QuitButton.qml
       ShapeExplorer/Rabbit.qml
       ShapeExplorer/Shape.qml
       ShapeExplorer/TargetSlot.qml
       ShapeExplorer/Telemetry.js

       #Reognition Files
       QML_FILES Recognition_Shape_Explorer_Level1.qml
       QML_FILES Recognition_Shape_Explorer_Level2.qml
       QML_FILES Recognition_Shape_Explorer_Level3.qml







)


qt_add_resources(Recognition
       "recognition_assets"
        PREFIX "/recognition"
        FILES "ShapeExplorer/assets/background.png"
        FILES "ShapeExplorer/assets/circle.png"
        FILES "ShapeExplorer/assets/circle_original.png"
        FILES "ShapeExplorer/assets/failure.mp3"
        FILES "ShapeExplorer/assets/failure.wav"
        FILES "ShapeExplorer/assets/game_background.png"
        FILES "ShapeExplorer/assets/rabbit.png"
        FILES "ShapeExplorer/assets/rabbit_appear.mp3"
        FILES "ShapeExplorer/assets/rabbit_appear.wav"
        FILES "ShapeExplorer/assets/rabbit_original.png"
        FILES "ShapeExplorer/assets/replay_button.png"

        FILES "ShapeExplorer/assets/replay_button_original.png"
        FILES "ShapeExplorer/assets/square.png"
        FILES "ShapeExplorer/assets/square_original.png"
        FILES "ShapeExplorer/assets/star.png"
        FILES "ShapeExplorer/assets/star_original.png"
        FILES "ShapeExplorer/assets/success.mp3"
        FILES "ShapeExplorer/assets/success.wav"
        FILES "ShapeExplorer/assets/triangle.png"
        FILES "ShapeExplorer/assets/triangle_original.png"
)

# target_include_directories(Recognition PUBLIC src)

# target_link_libraries(${PROJECT_NAME}lib PRIVATE Qt6::Core)

target_link_libraries(Recognition
    PRIVATE Qt6::Quick
    Qt6::Qml
    Qt6::Gui
    Qt6::Quick
    Qt6::Network
    Qt6::quickmultimedia
)

