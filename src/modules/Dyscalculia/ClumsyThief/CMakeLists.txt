qt_add_qml_module(ClumsyThief
STATIC
URI Dyscalculia.ClumsyThief
RESOURCE_PREFIX "/modules/dyscalculia/clumsythief"
QML_FILES ClumsyMain.qml
QML_FILES GameBoard.qml
QML_FILES MetricsDashboard.qml

SOURCES gameengine.cpp gameengine.h

)

qt_add_resources(ClumsyThief
    "clumsythief_assets"
     PREFIX "/clumsythief"
     FILES assets/card_back.png
     FILES assets/game_background.png
     FILES assets/game_music.wav
     FILES assets/jail_card.png
     FILES assets/money_card_10.png
     FILES assets/success_sfx.wav
     FILES assets/thief_card.png
)
