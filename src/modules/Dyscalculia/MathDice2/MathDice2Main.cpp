/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "MersenneTwister.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    app.setOrganizationName("MathDiceMaster");
    app.setOrganizationDomain("com.mathdice.master");
    app.setApplicationName("MathDiceMasterGame");

    QQmlApplicationEngine engine;

    // Register our C++ MT19937 randomizer directly to QML
    qmlRegisterType<MersenneTwister>("com.mathdice.rng", 1, 0, "MersenneTwister");

    const QUrl url(QStringLiteral("qrc:/com/mathdice/master/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
