#include <QGuiApplication>
#include <QQmlApplicationEngine>
// #include "CoreSettings.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    // engine.addImportPath(QString("%1/src/UIModule").arg(QGuiApplication::applicationDirPath()));
    // engine.addImportPath(QString("%1/src/coreLib").arg(QGuiApplication::applicationDirPath()));
    // engine.addImportPath(":/");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("AppController", "Main");
    // engine.load(QUrl(QStringLiteral("qrc:/mvpDyxiV1/UIModule/main.qml")));


    return QCoreApplication::exec();
}
