#include <QGuiApplication>
#include <QQmlApplicationEngine>
// #include "CoreSettings.hpp"
#include <QIcon>
#include <QSslSocket>
#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("Dyxi Mvp");
    app.setApplicationDisplayName("Dyxi Mvp");

    // Set the application-wide icon (Used for main window and taskbar)
    app.setWindowIcon(QIcon("qrc:/ui/UIModule/images/logo.png"));

    qDebug() << "Supports SSL: " << QSslSocket::supportsSsl();
    qDebug() << "SSL Library Build Version: " << QSslSocket::sslLibraryBuildVersionString();
    qDebug() << "SSL Library Runtime Version: " << QSslSocket::sslLibraryVersionString();

    QQmlApplicationEngine engine;
    // engine.addImportPath(QString("%1/src/UIModule").arg(QGuiApplication::applicationDirPath()));
    // engine.addImportPath(QString("%1/src/coreLib").arg(QGuiApplication::applicationDirPath()));
    // engine.addImportPath(":/");

    // QObject::connect();

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
