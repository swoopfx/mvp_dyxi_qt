cmake_minimum_required(VERSION 3.16)

project(TenFrameGame VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Gui Qml Quick Multimedia)

qt_standard_project_setup()

qt_add_executable(TenFrameGame
    src/main.cpp
    src/gameengine.h src/gameengine.cpp
    src/metricsengine.h src/metricsengine.cpp
    src/sessionlogger.h src/sessionlogger.cpp
    src/qml.qrc
)

target_link_libraries(TenFrameGame PRIVATE 
    Qt6::Gui 
    Qt6::Qml 
    Qt6::Quick 
    Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS TenFrameGame
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
