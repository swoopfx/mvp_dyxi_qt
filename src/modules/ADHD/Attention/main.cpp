#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "cognitiveengine.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("ADHD Cognitive Tracker");
    app.setApplicationVersion("1.0.0");

    QQmlApplicationEngine engine;

    CognitiveEngine cognitiveEngine;
    engine.rootContext()->setContextProperty("cognitiveEngine", &cognitiveEngine);

    const QUrl url(u"qrc:/AdhdWhackProject/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
