qt_add_executable(AppController
    main.cpp
)

qt_add_qml_module(AppController
    URI AppController
    QML_FILES
        Main.qml

)

# target_include_directories(AppController
#     PRIVATE ${CMAKE_SOURCE_DIR}/src/UIModule
# )

target_include_directories(AppController
    PRIVATE ${CMAKE_SOURCE_DIR}/src/coreLib/General
)

target_link_libraries(AppController
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core

    UIModule
    Generalplugin
    Datasetplugin
    Recognitionplugin
    Writingplugin
    modulesplugin
    # ShapeExplorerplugin


)

target_link_libraries(AppController PRIVATE Generalplugin)
target_link_libraries(AppController PRIVATE Datasetplugin)
target_link_libraries(AppController PRIVATE Recognitionplugin)
target_link_libraries(AppController PRIVATE Writingplugin)
target_link_libraries(AppController PRIVATE modulesplugin)
# target_link_libraries(AppController PRIVATE ShapeExplorerplugin)


