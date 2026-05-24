#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "gameengine.h"

int main(int argc, char *argv[]) {
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
    
    qmlEngine.load(url);

    return app.exec();
}
