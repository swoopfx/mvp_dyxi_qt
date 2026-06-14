#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "cognitive_engine.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    // Register CognitiveEngine to the Qml Declarative layer
    qmlRegisterType<CognitiveEngine>("CognitiveTelemetry.Engine", 1, 0, "CognitiveEngine");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/CognitiveTelemetry/Engine/main.qml"_qs);
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
        
    engine.load(url);

    return app.exec();
}
