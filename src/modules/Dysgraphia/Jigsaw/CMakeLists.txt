 
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
        RESOURCE_PREFIX "/modules/dysgraphia/jigsaw"
    VERSION 1.0
    QML_FILES
        JigsawMain.qml
        JigsawGrid.qml
        JigsawPiece.qml
    SOURCES
        cognitive_engine.h
        cognitive_engine.cpp
)

target_link_libraries(Jigsaw PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
)