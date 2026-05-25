# cmake_minimum_required(VERSION 3.16)

# project(WordRecognitionGame VERSION 0.1 LANGUAGES CXX)

# set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Gui Qml Quick TextToSpeech)

qt_add_qml_module(WordRecognitionGame
    # src/main.cpp
    # src/gameengine.h
    # src/gameengine.cpp
    # resources.qrc

        STATIC
        URI Phonetics.WordRecognitionGame
        RESOURCE_PREFIX "/modules/phonetics/wordrecog"

        SOURCES gameenginew.cpp gameenginew.h

        QML_FILES WordRecognitionMain.qml
)

qt_add_resources(WordRecognitionGame
    "wordrecognitiongame_assets"
     PREFIX "/wordrecognitiongame"
     FILES assets/images/bat.png
     FILES assets/images/car.png
     FILES assets/images/cat.png
     FILES assets/images/cow.png
     FILES assets/images/dog.png
     FILES assets/images/fox.png
     FILES assets/images/hen.png
     FILES assets/images/pig.png
     FILES assets/images/sun.png
 )

target_link_libraries(WordRecognitionGame PRIVATE
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::TextToSpeech
)

# install(TARGETS WordRecognitionGame
#     BUNDLE DESTINATION .
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
# )
