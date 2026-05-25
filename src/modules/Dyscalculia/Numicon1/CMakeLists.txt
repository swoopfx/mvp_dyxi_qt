
qt_add_qml_module(Numicon1
    STATIC
    URI Dyscalculia.Numicon1
    RESOURCE_PREFIX "/modules/dyscalculia/numicon1"
    QML_FILES NumiconMain.qml
    QML_FILES NumiconShape.qml

    SOURCES metrictracker.cpp metrictracker.h
    SOURCES gameenginen.cpp gameenginen.h

)

qt_add_resources(Numicon1
    "numicon1_assets"
     PREFIX "/numicon1"
     FILES assets/audio/background_music.mp3
     FILES assets/audio/success.wav
     FILES assets/audio/try_again.wav

     # FILES assets/images/game_background.jpg
      FILES assets/images/numicon_1.png
       FILES assets/images/numicon_10.png
        FILES assets/images/numicon_10_original.png
         FILES assets/images/numicon_1_original.png
          FILES assets/images/numicon_2.png
           FILES assets/images/numicon_2_original.png
            FILES assets/images/numicon_3.png
             FILES assets/images/numicon_3_original.png
              FILES assets/images/numicon_4.png
               FILES assets/images/numicon_4_original.png
                FILES assets/images/numicon_5.png
                 FILES assets/images/numicon_5_original.png
                  FILES assets/images/numicon_6.png
                   FILES assets/images/numicon_6_original.png
                    FILES assets/images/numicon_7.png
                     FILES assets/images/numicon_7_original.png
                      FILES assets/images/numicon_8.png
                       FILES assets/images/numicon_8_original.png
                        FILES assets/images/numicon_9.png
                         FILES assets/images/numicon_9_original.png
)

