#include "gameengine.h"
#include <QRandomGenerator>
#include <QDateTime>
#include <QJsonDocument>
#include <QDebug>
#include <QUuid>
#include <QFile>
#include <QDir>

GameEngine::GameEngine(QObject *parent) : QObject(parent), m_isRecording(false)
{
    m_sessionId = QUuid::createUuid().toString();
    loadWordDatabase();
    nextWord();
}

void GameEngine::loadWordDatabase()
{
    // Simplified for simulation, normally read from file
    m_wordDatabase << "Cat" << "Dog" << "Pig" << "Cow" << "Hen" << "Fox" << "Bat" << "Sun" << "Car";
}

void GameEngine::nextWord()
{
    if (m_wordDatabase.isEmpty()) return;
    int index = QRandomGenerator::global()->bounded(m_wordDatabase.size());
    m_currentWord = m_wordDatabase.at(index);
    m_currentImage = QString("qrc:/assets/images/%1.png").arg(m_currentWord.toLower());
    emit currentWordChanged();
    emit currentImageChanged();
    logEvent("word_displayed", {{"word", m_currentWord}});
}

void GameEngine::startRecording()
{
    m_isRecording = true;
    emit isRecordingChanged();
    logEvent("recording_started");
}

void GameEngine::stopRecording()
{
    m_isRecording = false;
    emit isRecordingChanged();
    QString fileName = QString("rec_%1.wav").arg(QDateTime::currentMSecsSinceEpoch());
    emit recordingFinished(fileName);
    logEvent("recording_stopped", {{"file", fileName}});
}

void GameEngine::logEvent(const QString &event, const QVariantMap &data)
{
    QJsonObject eventObj;
    eventObj["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    eventObj["event"] = event;
    eventObj["data"] = QJsonObject::fromVariantMap(data);
    m_eventLog.append(eventObj);
    qDebug() << "Event Logged:" << event;
}

void GameEngine::submitMetrics(const QVariantMap &metrics)
{
    QJsonObject metricsObj = QJsonObject::fromVariantMap(metrics);
    metricsObj["session_id"] = m_sessionId;
    
    // Calculate advanced metrics as requested
    calculateAdvancedMetrics(metricsObj);
    
    QJsonObject payload;
    payload["metrics"] = metricsObj;
    payload["events"] = m_eventLog;
    
    simulateApiCall(payload, metrics["audio_file"].toString());
}

void GameEngine::calculateAdvancedMetrics(QJsonObject &metricsObj)
{
    // Heavy logic simulation
    double timeTaken = metricsObj["time_taken_ms"].toDouble();
    
    // Fluency Index: Inverse of time taken (normalized)
    metricsObj["fluency_index"] = qBound(0.0, 10000.0 / (timeTaken + 1), 1.0);
    
    // Accuracy: Simulated for now
    metricsObj["accuracy"] = 0.95;
    
    // Vocabulary Knowledge: Based on session history
    metricsObj["vocabulary_knowledge"] = 0.8;
    
    // Memory Capacity: Simulated
    metricsObj["memory_capacity"] = 0.75;
    
    // Progress Monitoring Index
    metricsObj["progress_monitoring_index"] = 0.85;
}

void GameEngine::simulateApiCall(const QJsonObject &payload, const QString &audioPath)
{
    qDebug() << "Simulating API POST to https://api.dummy-backend.com/v1/metrics";
    
    // Simulate network delay
    QTimer::singleShot(1500, this, [this, audioPath]() {
        bool success = (QRandomGenerator::global()->bounded(100) > 10); // 90% success rate
        
        if (success) {
            emit apiResponseReceived(true, "Metrics and audio uploaded successfully.");
            logEvent("api_success");
        } else {
            QString error = "Network Error: Failed to upload audio file " + audioPath;
            emit apiResponseReceived(false, error);
            logEvent("api_error", {{"error", error}});
        }
    });
}
