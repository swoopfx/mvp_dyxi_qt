project(AdhdModule VERSION 0.1 LANGUAGES CXX)
# set_source_files_properties(resources)

# add_library(${PROJECT_NAME}lib STATIC)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia QuickControls2  Network Core)

qt_add_qml_module(
    ${PROJECT_NAME}lib
    STATIC
    URI ${PROJECT_NAME}

    QML_FILES
    SOURCES src/apa.h src/apa.cpp
    SOURCES src/tracabletext.h src/tracabletext.cpp

)



target_include_directories(${PROJECT_NAME}lib PUBLIC src)

target_link_libraries(${PROJECT_NAME}lib PRIVATE Qt6::Core)

target_link_libraries(${PROJECT_NAME}lib
    PRIVATE Qt6::Quick
)

