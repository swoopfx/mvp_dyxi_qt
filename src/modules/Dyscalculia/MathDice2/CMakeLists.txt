 
# Define the C++ components of the application
# qt_add_executable(MathDice2
#     # MathDice2Main.cpp

# )

# Define QML resources and files to bundle
qt_add_qml_module(MathDice2
       STATIC
    URI MathDice2
    RESOURCE_PREFIX "/modules/dyscalculia/mathdice2"
    VERSION 1.0
    QML_FILES
    MathDice2Main.qml
        MathDiceBoard.qml
        CognitiveDashboard.qml
        ConcentrationBooster.qml

    SOURCES
          MersenneTwister.h
          MersenneTwister.cpp
)


# Link Qt libraries
target_link_libraries(MathDice2
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
)

# Deploy scripts or installers configurations can be added below for release targets
# install(TARGETS MathDice2
#     BUNDLE DESTINATION .
#     LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
# )
