# add_library(modules STATIC
#     #login.cpp
# )
find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Network Multimedia)
qt_add_qml_module(modules
    STATIC
    URI modules
    RESOURCE_PREFIX "/modules"
    QML_FILES
     QML_FILES Recognition_Shape_Explorer_Level1.qml
     QML_FILES Recognition_Shape_Explorer_Level2.qml
     QML_FILES Recognition_Shape_Explorer_Level3.qml

     QML_FILES  ShapeExplorer/QuitButton.qml
      QML_FILES ShapeExplorer/Rabbit.qml
     QML_FILES  ShapeExplorer/Shape.qml
      QML_FILES ShapeExplorer/TargetSlot.qml
     QML_FILES  ShapeExplorer/Telemetry.js
     QML_FILES EntryPoint.qml
     # SOURCES ShapeExplorer/audiomanagerx.h ShapeExplorer/audiomanagerx.cpp

     SOURCES recogaudiomanager.h
     SOURCES recogaudiomanager.cpp

       # #Reognition Files
       # QML_FILES Recognition_Shape_Explorer_Level1.qml
       # QML_FILES Recognition_Shape_Explorer_Level2.qml
       # QML_FILES Recognition_Shape_Explorer_Level3.qml

)

qt_add_resources(modules
       "recognition_assets"
        PREFIX "/Recognition"
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

target_link_libraries(modules PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Network
    Qt6::Multimedia
)

add_subdirectory(ADHD)
add_subdirectory(Dyscalculia)
add_subdirectory(Dyslexia)
add_subdirectory(Recognition)
add_subdirectory(Writing)
add_subdirectory(Phonetics)
add_subdirectory(Dysgraphia)
