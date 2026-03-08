cmake_minimum_required(VERSION 3.16)

project(mvpDyxi VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Network Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appmvpDyxi
    main.cpp
    images.qrc
)

qt_add_qml_module(appmvpDyxi
    URI mvpDyxi
    QML_FILES
        Main.qml
        RESOURCES images.qrc
        QML_FILES Pages/Welcome.qml
        QML_FILES Buttons/PulseButton.qml
        QML_FILES Pages/SelectionPage.qml
        QML_FILES Basee.qml
        SOURCES src/connectionservice.h src/connectionservice.cpp
        QML_FILES Buttons/NeonButton.qml
        QML_FILES Games/Dyslexia/Game1.qml
        QML_FILES Buttons/ConfetiButton.qml
        QML_FILES Buttons/DefaultButton.qml
        QML_FILES Pages/SelectGamePage.qml
        SOURCES src/AllString.h
        SOURCES src/settings.h src/settings.cpp
        SOURCES Games/Dyslexia/dyxlearnengine.h Games/Dyslexia/dyxlearnengine.cpp
        QML_FILES Components/ImageButton.qml
        QML_FILES Games/ADHD/Game1.qml
        QML_FILES Games/ADHD/NewGame2.qml
        QML_FILES Components/LeftNavigation.qml
        QML_FILES Components/Playground.qml
        SOURCES
        SOURCES src/timer.h src/timer.cpp
        QML_FILES Games/Dyslexia/Level1_Writing_English_Dyslexia.qml
        QML_FILES js/script.js
        QML_FILES Games/Dyslexia/Level1_Recognition_English_Dyslexia.qml
        QML_FILES Games/Dyslexia/Level1_Tracing_English_Dyslexia.qml
        QML_FILES Games/Dyslexia/Level0_Tracing_English_Dyslexia.qml
)

qt_add_resources(appmvpDyxi
    "assets"
     PREFIX "/img"
     FILES "images/Welcome Dyxi.png"
     FILES "images/Artboard.png"
     FILES "images/kidi.jpg"
     FILES "images/playground.jpg"
     FILES "images/ADHD_Symbol.png"
     FILES "images/Dyslexia_Symbol.png"

 )

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appmvpDyxi PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmvpDyxi
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmvpDyxi
    PRIVATE Qt6::Quick Qt6::Network

)

include(GNUInstallDirs)
install(TARGETS appmvpDyxi
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
