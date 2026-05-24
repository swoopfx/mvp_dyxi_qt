#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "gameengine.h"
#include "metricsengine.h"
#include "sessionlogger.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    GameEngine gameEngine;
    MetricsEngine metricsEngine;
    SessionLogger sessionLogger;

    // Connect signals for metrics and logging
    QObject::connect(&gameEngine, &GameEngine::questionAsked, &metricsEngine, &MetricsEngine::onQuestionAsked);
    QObject::connect(&gameEngine, &GameEngine::answerSubmitted, &metricsEngine, &MetricsEngine::onAnswerSubmitted);
    
    QObject::connect(&gameEngine, &GameEngine::questionAsked, &sessionLogger, &SessionLogger::onQuestionAsked);
    QObject::connect(&gameEngine, &GameEngine::answerSubmitted, &sessionLogger, &SessionLogger::onAnswerSubmitted);

    QQmlApplicationEngine engine;
    
    // Expose C++ objects to QML
    engine.rootContext()->setContextProperty("gameEngine", &gameEngine);
    engine.rootContext()->setContextProperty("metricsEngine", &metricsEngine);
    engine.rootContext()->setContextProperty("sessionLogger", &sessionLogger);

    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}
