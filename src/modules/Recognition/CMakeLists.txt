 
project(Recognition VERSION 0.1 LANGUAGES CXX)
# set_source_files_properties(resources)

# add_library(${PROJECT_NAME}lib STATIC)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia QuickControls2  Network Core)

# qt_add_executable()

qt_add_qml_module(
    Recognition
    STATIC
    URI Recognition
    RESOURCE_PREFIX "/Recognition"



       #Reognition Files
       QML_FILES Recognition_Shape_Explorer_Level1.qml
       QML_FILES Recognition_Shape_Explorer_Level2.qml
       QML_FILES Recognition_Shape_Explorer_Level3.qml








)




# target_include_directories(Recognition PUBLIC src)

# target_link_libraries(${PROJECT_NAME}lib PRIVATE Qt6::Core)

target_link_libraries(Recognition
    PRIVATE Qt6::Quick
    Qt6::Qml
    Qt6::Gui
    Qt6::Quick
    Qt6::Network
     Qt6::Multimedia
)

# add_subdirectory(ShapeExplorer)

