 
qt_add_qml_module(MathDice
    STATIC
    URI Dyscalculia.MathDice
    RESOURCE_PREFIX "/modules/dyscalculia/mathdice"
    QML_FILES  MathDiceMain.qml
    QML_FILES MetricRow.qml
    QML_FILES MetricsDashboard.qml
    QML_FILES AnimatedDice.qml

    SOURCES gameengine.cpp gameengine.h
)

qt_add_resources(MathDice
    "mathdice_assets"
     PREFIX "/mathdice"
     FILES assets/images/background_main.png
     FILES assets/images/dice_base.png
     FILES assets/images/ui_button_base.png

     FILES assets/audio/game_soundtrack.mp3
)