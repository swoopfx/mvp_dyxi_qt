#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "speechengine.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Register our C++ Whisper-powered speech engine component to QML namespaces
    qmlRegisterType<SpeechEngine>("RobotTalkGame", 1, 0, "SpeechEngine");

    QQmlApplicationEngine engine;
    
    const QUrl url(u"qrc:/RobotTalkGame/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
