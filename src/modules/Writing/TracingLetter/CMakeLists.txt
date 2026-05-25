 
qt_add_qml_module(TracingLetter

    URI Writing.TracingLetter
    STATIC
    RESOURCE_PREFIX "/modules/writing/tracingletter"
    QML_FILES  TracingLetterMain.qml
    QML_FILES Component/Tracer.qml
    QML_FILES TracingWordMain.qml
)