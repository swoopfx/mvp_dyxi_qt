#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "mazeengine.h"

int main(int argc, char *argv[])
{
    // High DPI scaling standard for modern dashboards and displays
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/assets/app_icon.png"));
    app.setOrganizationName("CogniMazeLabs");
    app.setOrganizationDomain("cognimaze-clinic.org");
    app.setApplicationName("ADHD CogniMaze");

    // Register our C++ Cognitive Analytics Engine to be exposed as an instantiable QML Type
    qmlRegisterType<MazeEngine>("ADHDCogniMaze", 1, 0, "MazeEngine");

    QQmlApplicationEngine engine;
    
    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}
