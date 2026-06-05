include(FetchContent)

find_package(Qt6 REQUIRED COMPONENTS
    Quick
    Multimedia
    Core5Compat
)

qt_add_executable(AppController
    main.cpp
)

qt_add_qml_module(AppController
    URI AppController
    QML_FILES
        Main.qml

)

# qt_add_resources(AppController
#     "assets"
#      PREFIX "/app"
#  )

# target_include_directories(AppController
#     PRIVATE ${CMAKE_SOURCE_DIR}/src/UIModule
# )

target_include_directories(AppController
    PRIVATE ${CMAKE_SOURCE_DIR}/src/coreLib/General
)
set_target_properties(AppController PROPERTIES
    QT_ANDROID_MIN_VERSION 33
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
    # QT_ANDROID_EXTRA_LIBS
    #     "${CMAKE_SOURCE_DIR}/android/libs/arm64-v8a/libmagtsync.so;
    #      ${CMAKE_SOURCE_DIR}/android/libs/armeabi-v7a/libmagtsync.so"
)


if (ANDROID)
    FetchContent_Declare(
      android_openssl
      DOWNLOAD_EXTRACT_TIMESTAMP true
      URL https://github.com/KDAB/android_openssl/archive/refs/heads/master.zip
#      URL_HASH MD5=c97d6ad774fab16be63b0ab40f78d945 #optional
    )
    FetchContent_MakeAvailable(android_openssl)
    include(${android_openssl_SOURCE_DIR}/android_openssl.cmake)
endif()



target_link_libraries(AppController
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
    PRIVATE    Qt6::Multimedia
    PRIVATE  Qt6::Core5Compat

    UIModule
    Generalplugin
    Datasetplugin
    Recognitionplugin
    Writingplugin
    modulesplugin
    MathDiceplugin
    ClumsyThiefplugin
    Numicon1plugin
    # TenFrameGameplugin
    TenFramesplugin
    # ShapeExplorerplugin
    WordRecognitionGameplugin
    TracingLetterplugin


)

# qt_add_android_permission(AppController NAME  "android.permission.INTERNET")
# qt_add_android_permission(AppController NAME "android.permission.ACCESS_NETWORK_STATE")


target_link_libraries(AppController PRIVATE Generalplugin)
target_link_libraries(AppController PRIVATE Datasetplugin)
target_link_libraries(AppController PRIVATE Recognitionplugin)
target_link_libraries(AppController PRIVATE Writingplugin)
target_link_libraries(AppController PRIVATE modulesplugin)
target_link_libraries(AppController PRIVATE MathDiceplugin)
target_link_libraries(AppController PRIVATE ClumsyThiefplugin)
target_link_libraries(AppController PRIVATE TenFramesplugin)
target_link_libraries(AppController PRIVATE Numicon1plugin)
target_link_libraries(AppController PRIVATE WordRecognitionGameplugin)
target_link_libraries(AppController PRIVATE TracingLetterplugin)




