#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "gameengine.h"
#include "metrictracker.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    GameEngine engine;
    MetricTracker tracker;

    QQmlApplicationEngine qmlEngine;
    qmlEngine.rootContext()->setContextProperty("gameEngine", &engine);
    qmlEngine.rootContext()->setContextProperty("metricTracker", &tracker);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&qmlEngine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    // For this environment, we just provide the source files.
    // In a real build, we would use a .pro or CMakeLists.txt
    qmlEngine.load(QUrl::fromLocalFile("/home/ubuntu/numicon_game/main.qml"));

    return app.exec();
}
