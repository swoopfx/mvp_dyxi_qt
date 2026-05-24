cmake_minimum_required(VERSION 3.16)
project(TinyPolkaDot VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick Multimedia REQUIRED)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appTinyPolkaDot
    main.cpp
)

qt_add_qml_module(appTinyPolkaDot
    URI TinyPolkaDot
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES gameengine.cpp gameengine.h
)

target_link_libraries(appTinyPolkaDot
    PRIVATE Qt6::Quick Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS appTinyPolkaDot
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
