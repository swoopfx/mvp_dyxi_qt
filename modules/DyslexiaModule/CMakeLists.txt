cmake_minimum_required(VERSION 3.16)

project(DyslexiaModule VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)


find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)



qt_add_qml_module(appDyslexiaModule

    URI DyslexiaModule
    QML_FILES


     SOURCES src/tt.h src/tt.cpp
      # src/tracabletext.cpp
      # src/tracabletext.h

    RESOURCES
    QML_FILES Entry.qml
    # SOURCES src/tt.cpp
    # SOURCES src/tt.cpp
)

# file(GLOB_RECURSE PROJECT_SOURCES RELATIVE
#     ${CMAKE_CURRENT_SOURCE_DIR}
#     "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

# file(GLOB_RECURSE PROJECT_HEADER "src/*.h")

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appDyslexiaModule PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appDyslexiaModule
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appDyslexiaModule
    PRIVATE Qt6::Quick
)

install(TARGETS appDyslexiaModule
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

target_include_directories(appDyslexiaModule PRIVATE
src)

 add_subdirectory(modules/Phonics)
