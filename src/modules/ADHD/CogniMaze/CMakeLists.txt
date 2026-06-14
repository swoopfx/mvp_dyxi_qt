
find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Network Multimedia)

# qt_standard_project_setup()



qt_add_qml_module(CogniMaze
    STATIC
    URI CogniMaze
    VERSION 1.0
     RESOURCE_PREFIX "/modules/adhd/cognimaze"
    QML_FILES CogniMazeMain.qml
	
    SOURCES
    # CogniMazeMain.cpp
        mazeengine.h
        mazeengine.cpp

    RESOURCES
        assets/success.wav
        assets/wall.wav
        assets/bubble.wav
)

target_link_libraries(CogniMaze PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Network
    Qt6::Multimedia
)

install(TARGETS CogniMaze
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} 
)
