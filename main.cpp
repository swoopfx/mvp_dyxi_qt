#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "src/connectionservice.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    ConnectionService service ;
    engine.rootContext()->setContextProperty("service", &service);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("mvpDyxi", "Main");

    return app.exec();
}
