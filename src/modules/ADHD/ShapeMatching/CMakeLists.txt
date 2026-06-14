
find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Network Multimedia)


qt_add_qml_module(ShapeMatching
    STATIC
    URI ShapeMatching
    VERSION 1.0
     RESOURCE_PREFIX "/modules/adhd/shapematching"
    QML_FILES
        ShapeMatchingMain.qml
        EasyPage.qml
        HardPage.qml
        ShapeItem.qml
        MediumPage.qml


    SOURCES
        telemetrybackend.h
        telemetrybackend.cpp

    # RESOURCES
    #     assets/success.wav
    #     assets/wall.wav
    #     assets/bubble.wav
)

target_link_libraries(ShapeMatching PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Multimedia
)