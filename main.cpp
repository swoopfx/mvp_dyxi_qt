#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "src/connectionservice.h"
#include "src/AllString.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    QCoreApplication::setOrganizationName(AllString::companyName);
    QCoreApplication::setApplicationName(AllString::appName);

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
