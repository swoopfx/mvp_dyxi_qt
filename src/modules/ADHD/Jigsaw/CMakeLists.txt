 
find_package(Qt6 REQUIRED COMPONENTS Quick Qml Core)

#qt_standard_project_setup()

# Define source targets
# qt_add_executable(Jigsaw
#    # main.cpp

# )

# Set Qml imports structure
qt_add_qml_module(Jigsaw
    #URI CognitiveTelemetry.Engine
    STATIC
        URI Jigsaw
        RESOURCE_PREFIX "/modules/adhd/jigsaw"
    VERSION 1.0
    QML_FILES
        JigsawMain.qml
        JigsawGrid.qml
        JigsawPiece.qml
    SOURCES
        cognitive_engine.h
        cognitive_engine.cpp
)


qt_add_resources(Jigsaw
    "assets"
     PREFIX "/modules/jigsaw"
     FILES "assets/fox.png"
     FILES "assets/koala.png"
     FILES "assets/panda.png"
 )
target_link_libraries(Jigsaw PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
)