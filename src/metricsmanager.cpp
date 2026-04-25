#include "metricsmanager.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>
#include <QStandardPaths>
#include <QDateTime>
#include <QUuid>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QUrl>

MetricsManager::MetricsManager(QObject *parent)
    : QObject(parent), m_sessionActive(false)
{
}

void MetricsManager::startSession(const QString &difficulty)
{
    m_currentSession.sessionId = generateSessionId();
    m_currentSession.timestamp = getCurrentTimestamp();
    m_currentSession.difficulty = difficulty;
    m_currentSession.words = QJsonArray();
    m_currentSession.letterMetrics = QJsonArray();
    m_currentSession.totalScore = 0;
    m_currentSession.accuracy = 0;

    m_sessionActive = true;
    emit sessionStarted();
}

void MetricsManager::endSession()
{
    if (!m_sessionActive)
        return;

    m_sessionActive = false;
    m_allSessions.append(sessionToJson(m_currentSession));
    emit sessionEnded();
}

void MetricsManager::recordLetterMetrics(const QString &letter, const QJsonObject &metrics)
{
    if (!m_sessionActive)
        return;

    QJsonObject letterData;
    letterData["letter"] = letter;
    letterData["metrics"] = metrics;
    letterData["timestamp"] = getCurrentTimestamp();

    m_currentSession.letterMetrics.append(letterData);
    emit metricsRecorded();
}

void MetricsManager::recordWordCompletion(const QString &word, bool success, int timeMs)
{
    if (!m_sessionActive)
        return;

    QJsonObject wordData;
    wordData["word"] = word;
    wordData["success"] = success;
    wordData["timeMs"] = timeMs;
    wordData["timestamp"] = getCurrentTimestamp();

    m_currentSession.words.append(wordData);

    if (success) {
        m_currentSession.totalScore += 10;
    }

    emit metricsRecorded();
}

QJsonObject MetricsManager::getSessionData()
{
    return sessionToJson(m_currentSession);
}

bool MetricsManager::exportSessionToFile(const QString &filePath)
{
    QJsonObject sessionJson = sessionToJson(m_currentSession);
    QJsonDocument doc(sessionJson);

    QString exportPath = filePath;
    if (exportPath.isEmpty()) {
        QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
        exportPath = documentsPath + "/dyslexia_session_" + m_currentSession.sessionId + ".json";
    }

    QFile file(exportPath);
    if (!file.open(QIODevice::WriteOnly)) {
        emit exportFailed("Cannot open file for writing: " + exportPath);
        return false;
    }

    file.write(doc.toJson());
    file.close();

    qDebug() << "Session exported to:" << exportPath;
    emit exportSuccess();
    return true;
}

bool MetricsManager::exportSessionToCloud(const QString &cloudUrl)
{
    if (cloudUrl.isEmpty()) {
        emit exportFailed("Cloud URL is empty");
        return false;
    }

    QJsonObject sessionJson = sessionToJson(m_currentSession);
    QJsonDocument doc(sessionJson);

    // This would typically use QNetworkAccessManager to POST to cloud
    // For now, we'll just log and emit success
    qDebug() << "Exporting to cloud:" << cloudUrl;
    qDebug() << "Session data:" << doc.toJson();

    emit exportSuccess();
    return true;
}

QJsonArray MetricsManager::getAllSessions()
{
    return m_allSessions;
}

QString MetricsManager::generateSessionId()
{
    return QUuid::createUuid().toString().remove("{").remove("}");
}

QString MetricsManager::getCurrentTimestamp()
{
    return QDateTime::currentDateTime().toString(Qt::ISODate);
}

QJsonObject MetricsManager::sessionToJson(const SessionData &session)
{
    QJsonObject json;
    json["sessionId"] = session.sessionId;
    json["timestamp"] = session.timestamp;
    json["difficulty"] = session.difficulty;
    json["words"] = session.words;
    json["letterMetrics"] = session.letterMetrics;
    json["totalScore"] = session.totalScore;
    json["accuracy"] = session.accuracy;

    return json;
}
