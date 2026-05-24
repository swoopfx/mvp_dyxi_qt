#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "backend/GameEngine.h"
#include "backend/MetricsTracker.h"
#include "backend/ActivityLogger.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    ActivityLogger logger("numicon_activity_log.json");
    MetricsTracker metrics;
    GameEngine engine(&metrics, &logger);

    QQmlApplicationEngine qmlEngine;
    qmlEngine.rootContext()->setContextProperty("gameEngine", &engine);
    qmlEngine.rootContext()->setContextProperty("metricsTracker", &metrics);
    qmlEngine.rootContext()->setContextProperty("activityLogger", &logger);

    const QUrl url(QStringLiteral("qrc:/qml/MainView.qml"));
    QObject::connect(&qmlEngine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    qmlEngine.load(url);

    return app.exec();
}
