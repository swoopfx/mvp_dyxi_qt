#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "gameengine.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    GameEngine engine;
    QQmlApplicationEngine qmlEngine;
    
    qmlEngine.rootContext()->setContextProperty("gameEngine", &engine);
    
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&qmlEngine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    // For local testing without resources
    qmlEngine.load(QUrl::fromLocalFile("/home/ubuntu/robot_game/qml/main.qml"));

    return app.exec();
}
