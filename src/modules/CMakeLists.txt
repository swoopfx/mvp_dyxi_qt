# add_library(modules STATIC
#     #login.cpp
# )

qt_add_qml_module(
    modules
    STATIC
    URI modules
    RESOURCE_PREFIX "/modules"
    QML_FILES
     QML_FILES Recognition_Shape_Explorer_Level1.qml
       # ShapeExplorer/QuitButton.qml
       # ShapeExplorer/Rabbit.qml
       # ShapeExplorer/Shape.qml
       # ShapeExplorer/TargetSlot.qml
       # ShapeExplorer/Telemetry.js

       # #Reognition Files
       # QML_FILES Recognition_Shape_Explorer_Level1.qml
       # QML_FILES Recognition_Shape_Explorer_Level2.qml
       # QML_FILES Recognition_Shape_Explorer_Level3.qml







)

add_subdirectory(ADHD)
add_subdirectory(Dyscalculia)
add_subdirectory(Dyslexia)
add_subdirectory(Recognition)
add_subdirectory(Writing)
add_subdirectory(Phonetics)
