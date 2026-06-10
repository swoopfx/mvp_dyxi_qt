 
qt_add_executable(RobotTalk2
    # main.cpp
    speechengine.h
    speechengine.cpp
)

qt_add_qml_module(RobotTalk2
    URI RobotTalk2
    VERSION 1.0
    QML_FILES main.qml
)
