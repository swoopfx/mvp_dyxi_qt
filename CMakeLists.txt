cmake_minimum_required(VERSION 3.16)

project(mvpDyxi VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/)
set(QML_IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY}
    CACHE STRING "Import Path for qt Creator"
    FORCE
)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia QuickControls2  Network Core )

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appmvpDyxi
    main.cpp
    images.qrc
)

file(GLOB_RECURSE QML_FILES RELATIVE
    ${CMAKE_CURRENT_SOURCE_DIR}
    "${CMAKE_CURRENT_SOURCE_DIR}/Components/*qml"
    "${CMAKE_CURRENT_SOURCE_DIR}/Buttons/*qml"
    "${CMAKE_CURRENT_SOURCE_DIR}/Games/*qml"
    "${CMAKE_CURRENT_SOURCE_DIR}/Pages/*qml"
     "${CMAKE_CURRENT_SOURCE_DIR}/Recognition/*qml"
      "${CMAKE_CURRENT_SOURCE_DIR}/PageNew/*qml"
)

# file(GLOB_RECURSE PROJECT_SOURCES "src/*.cpp")
# file(GLOB_RECURSE PROJECT_HEADER "src/*.h")

# add_executable(appmvpDyxi ${PROJECT_SOURCES} ${PROJECT_HEADER})





qt_add_qml_module(appmvpDyxi
    URI mvpDyxi
    QML_FILES
        Main.qml
        RESOURCES images.qrc
        SOURCES src/AllString.h
        QML_FILES Pages/Welcome.qml
        QML_FILES Buttons/PulseButton.qml
        QML_FILES Pages/SelectionPage.qml
        QML_FILES Basee.qml
        QML_FILES Pages/LoadingPage.qml
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
         QML_FILES Components/GameItem.qml
        QML_FILES Games/ADHD/Game1.qml
        QML_FILES Games/ADHD/NewGame2.qml
        QML_FILES Components/LeftNavigation.qml
        QML_FILES Components/Playground.qml
        SOURCES src/timer.h src/timer.cpp
        QML_FILES Games/Dyslexia/Level1_Writing_English_Dyslexia.qml
        QML_FILES js/script.js
        QML_FILES Games/Dyslexia/Level1_Recognition_English_Dyslexia.qml
        QML_FILES Games/Dyslexia/Level1_Tracing_English_Dyslexia.qml
        QML_FILES Games/Dyslexia/Level0_Tracing_English_Dyslexia.qml
        QML_FILES Games/Dyslexia/Level1_Phonics_English_Dyslexia.qml
        QML_FILES Games/Dyslexia/LevelT_Tracing_English_Dyslexia.qml
        QML_FILES Games/Dyslexia/Component/MainMenu.qml
        QML_FILES Games/Dyslexia/Component/GameLevel.qml
        QML_FILES Games/Dyslexia/Component/PhonicsData.qml
        QML_FILES Games/Dyslexia/GameTest.qml
        QML_FILES ${QML_FILES}
        SOURCES src/tracingengine.h src/tracingengine.cpp
        # SOURCES src/audioengine.h src/audioengine.cpp
        SOURCES src/metricsmanager.h src/metricsmanager.cpp
        SOURCES src/wordmanager.h src/wordmanager.cpp
        SOURCES src/itemgametypeconnection.h src/itemgametypeconnection.cpp
        QML_FILES Pages/ItemGameTypePage.qml
        QML_FILES Components/ItemList.qml
        QML_FILES Pages/RobotPage.qml
        QML_FILES Components/Robot.qml
        QML_FILES Components/ColorDrop.qml
        QML_FILES Components/MetricTracker.qml
        QML_FILES Components/ColorCircle.qml
        QML_FILES Pages/ABC123.qml
        QML_FILES Pages/Tracing.qml
        SOURCES src/traceabletextitem.h src/traceabletextitem.cpp
        SOURCES mmm.h mmm.cpp
        SOURCES src/ano.h src/ano.cpp
        QML_FILES Pages/LoadingnPage.qml
        QML_FILES Pages/PlayGroundPage.qml
        QML_FILES Pages/TracePage.qml
        SOURCES src/traceabletexte.h src/traceabletexte.cpp
        QML_FILES Games/GameTelemetry.qml
        QML_FILES Pages/MainPlaygroundPage.qml
        QML_FILES Components/TelemetryLogger.qml
        QML_FILES PageNew/GameCategorySelectPage.qml
        QML_FILES PageNew/GameItemListPage.qml
        QML_FILES PageNew/PageLoader.qml
        QML_FILES Components/Delegate.qml Components/InfoModal.qml
        QML_FILES PageNew/PageDefaultPlaygroundLoader.qml


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
     FILES "images/phonics.jpg"
     FILES "images/reading.png"
     FILES "images/recognition.png"
     FILES "images/tracing.webp"
     FILES "images/writing.png"
     FILES "images/dyxi_logo_42.png"
     FILES "images/robot_body.svg"
     FILES "images/robot_head.svg"
     FILES "images/robot_limb.svg"
     FILES "Recognition/assets/images/background_main.png"
     FILES "Recognition/assets/images/button_play.png"
     FILES "Recognition/assets/images/button_play_original.png"
     FILES "Recognition/assets/images/card_base.png"
     FILES "Recognition/assets/images/card_base_original.png"
     FILES "Recognition/assets/images/character_guide.png"
     FILES "Recognition/assets/images/character_guide_original.png"
     FILES "images/logo.png"

 )

add_subdirectory(modules/AdhdModule)
add_subdirectory(modules/DyslexiaModule)
# add_subdirectory(modules/DyscalculiaModule)

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

target_include_directories(appmvpDyxi PUBLIC src )

target_link_libraries(appmvpDyxi
    PRIVATE
    Qt6::Qml
    Qt6::Gui
    Qt6::Quick
    Qt6::Network
    Qt6::quickmultimedia
    appDyslexiaModule
    AdhdModulelib
    # appDyscalculiaModule

)

include(GNUInstallDirs)
install(TARGETS appmvpDyxi
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)





# add_subdirectory(modules/Wiat4Module)
# add_subdirectory(modules/CTOPP2Module)
# add_subdirectory(modules/AdhdModule/modules/Phonics)
#