 
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    Network
    Multimedia
    TextToSpeech
)

# Enable automatic conversion
# qt_standard_project_setup()

# Compile class structure
# qt_add_executable(WordRecognitionGame2
#     main.cpp
#     speechprocessor.h
#     speechprocessor.cpp
# )

# Map QML resources beautifully
qt_add_qml_module(WordRecognitionGame2
    STATIC
    URI Phonetics.WordRecognitionGame2
    RESOURCE_PREFIX "/modules/phonetics/wordrecog2"
    VERSION 1.0

    DEPENDENCIES
          QtQuick
          QtMultimedia
          QtTextToSpeech

    QML_FILES
        WordRecog2Main.qml

    SOURCES

        speechprocessor.h
        speechprocessor.cpp

)

# Connect headers and shared linker flags
target_link_libraries(WordRecognitionGame2 PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Network
    Qt6::Multimedia
    Qt6::TextToSpeech
)

install(TARGETS WordRecognitionGame2
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
