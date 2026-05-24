#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "gameengine.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    GameEngine gameEngine;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("gameEngine", &gameEngine);
    
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
