#include <QGuiApplication>
#include <QQmlApplicationEngine>
// #include "CoreSettings.hpp"
#include <QIcon>
#include <QSslSocket>
#include <QDebug>
#include <QTextToSpeech>
#include <QtQml/qqml.h>
#include <QCoreApplication>
// #include <QCameraPermission>
#include <QGuiApplication>
// #include <QMicrophonePermission>
#include <QPermission>
// #include "../General/"


int main(int argc, char *argv[])
{

    // qputenv("QML_IMPORT_TRACE", "1");


    // QThread *networkThread = new QThread();
    // NetworkWorker *worker = new NetworkWorker();

    // // Move the worker object to the thread
    // worker->moveToThread(networkThread);

    // // Clean up the thread and worker when finished
    // connect(networkThread, &QThread::finished, worker, &QObject::deleteLater);
    // connect(networkThread, &QThread::finished, networkThread, &QObject::deleteLater);


    QGuiApplication app(argc, argv);

    app.setApplicationName("Dyxi Mvp");
    app.setApplicationDisplayName("Dyxi Mvp");

    // Set the application-wide icon (Used for main window and taskbar)
    app.setWindowIcon(QIcon("qrc:/ui/UIModule/images/logo.png"));

    // qDebug() << "Supports SSL: " << QSslSocket::supportsSsl();
    // qDebug() << "SSL Library Build Version: " << QSslSocket::sslLibraryBuildVersionString();
    // qDebug() << "SSL Library Runtime Version: " << QSslSocket::sslLibraryVersionString();

    // QTextToSpeech speech;
    // qDebug() << "State:" << speech.state();
    // qDebug() << "Available engines:"
    //          << QTextToSpeech::availableEngines();


    // Mic permision acces
    QMicrophonePermission micPermission;

    switch (app.checkPermission(micPermission)) {
    case Qt::PermissionStatus::Undetermined:
        app.requestPermission(micPermission,
                              [](const QPermission &permission) {
                                  if (permission.status() == Qt::PermissionStatus::Granted) {
                                      qDebug() << "Microphone permission granted";
                                      // Proceed with microphone usage
                                  } else {
                                      qDebug() << "Microphone permission denied";
                                  }
                              });
        break;

    case Qt::PermissionStatus::Denied:
        qDebug() << "Microphone permission denied";
        // Show instructions to enable permission in system settings
        break;

    case Qt::PermissionStatus::Granted:
        qDebug() << "Microphone permission already granted";
        // Proceed with microphone usage
        break;
    }







    QCameraPermission cameraPermission;

    switch (qApp->checkPermission(cameraPermission)) {
    case Qt::PermissionStatus::Undetermined:
        // The status is undetermined, request permission
        qApp->requestPermission(cameraPermission, [](const QPermission &permission) {
            if (permission.status() == Qt::PermissionStatus::Granted) {
                qDebug() << "Camera permission granted!";
                // TODO: Initialize camera here
            } else {
                qDebug() << "Camera permission denied!";
            }
        });
        break;
    case Qt::PermissionStatus::Granted:
        qDebug() << "Camera already granted.";
        // TODO: Initialize camera here
        break;
    case Qt::PermissionStatus::Denied:
        qDebug() << "Camera permission is denied.";
        break;
    }






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
