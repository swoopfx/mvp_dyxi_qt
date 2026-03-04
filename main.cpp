#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QScopedPointer>
#include "src/connectionservice.h"
#include "src/AllString.h"
#include <QVariant>



int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    QCoreApplication::setOrganizationName(AllString::companyName);
    QCoreApplication::setApplicationName(AllString::appName);

    QQmlApplicationEngine engine;
    QVariantMap activeUserData;
    // QScopedPointer<QSettings> appSetting(new QSettings(QCoreApplication::organizationName(), QCoreApplication::applicationName()));
    ConnectionService service ;
    engine.rootContext()->setContextProperty("service", &service);
    // engine.rootContext()->setContextProperty("appSettings", appSetting.data());
    engine.rootContext()->setContextProperty("sharedActiveUserData", QVariant::fromValue(activeUserData));
    // simple call sharedActiveUserData.key any where in the file
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("mvpDyxi", "Main");

    return app.exec();
}
