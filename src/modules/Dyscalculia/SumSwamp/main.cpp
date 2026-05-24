#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "gameengine.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    GameEngine engine;
    QQmlApplicationEngine qmlEngine;

    qmlEngine.rootContext()->setContextProperty("gameEngine", &engine);
    
    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    QObject::connect(&qmlEngine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    // In a real environment, we'd use a resource file (.qrc)
    // For this simulation, we load the file directly
    qmlEngine.load(QUrl::fromLocalFile("/home/ubuntu/sum_swamp_game/qml/Main.qml"));

    return app.exec();
}
