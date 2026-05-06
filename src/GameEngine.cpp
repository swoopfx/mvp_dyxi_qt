#include "GameEngine.h"
#include <QDebug>

GameEngine::GameEngine(QObject *parent) : QObject(parent)
{
    m_speech = new QTextToSpeech(this);
    m_sessionTimer.start();
    
    // Initial speech instruction
    speak("Welcome to Wiggly Words! Let's have some fun with letters!");
}

GameEngine::~GameEngine()
{
    saveLogs();
}

void GameEngine::speak(const QString &text)
{
    if (m_speech->state() == QTextToSpeech::Speaking) {
        m_speech->stop();
    }
    m_speech->say(text);
}

void GameEngine::logActivity(const QString &event, const QVariantMap &details)
{
    QJsonObject activity;
    activity["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    activity["event"] = event;
    activity["details"] = QJsonObject::fromVariantMap(details);
    
    // Update internal counters
    if (event == "letter_input") {
        m_totalActions++;
        if (details["is_correct"].toBool()) {
            m_correctActions++;
        }
    } else if (event == "word_completed") {
        m_wordsCompleted++;
        m_uniqueWords.insert(details["word"].toString());
    }

    updateMetrics();

    // Attach current telemetrics to the log
    QJsonObject telemetry;
    telemetry["accuracy"] = m_accuracy;
    telemetry["fluency_index"] = m_fluencyIndex;
    telemetry["vocab_knowledge"] = m_uniqueWords.size();
    telemetry["progress_monitoring_index"] = m_pmi;
    activity["telemetry"] = telemetry;

    m_activityLogs.append(activity);
    emit metricsChanged();
}

void GameEngine::updateMetrics()
{
    double elapsedMinutes = m_sessionTimer.elapsed() / 60000.0;
    
    m_accuracy = (m_totalActions > 0) ? (static_cast<double>(m_correctActions) / m_totalActions * 100.0) : 0.0;
    m_fluencyIndex = (elapsedMinutes > 0) ? (m_wordsCompleted / elapsedMinutes) : 0.0;
    
    // PMI calculation: weighted average of accuracy, fluency (normalized), and vocab (normalized)
    double vocabScore = qMin(100.0, (m_uniqueWords.size() / 10.0) * 100.0);
    double fluencyScore = qMin(100.0, m_fluencyIndex * 10.0);
    m_pmi = (m_accuracy * 0.4) + (fluencyScore * 0.3) + (vocabScore * 0.3);
}

QString GameEngine::metricsJson() const
{
    QJsonObject obj;
    obj["accuracy"] = QString::number(m_accuracy, 'f', 1);
    obj["fluency_index"] = QString::number(m_fluencyIndex, 'f', 2);
    obj["vocab_knowledge"] = m_uniqueWords.size();
    obj["progress_monitoring_index"] = QString::number(m_pmi, 'f', 1);
    return QJsonDocument(obj).toJson(QJsonDocument::Compact);
}

void GameEngine::saveLogs()
{
    QFile file("activity_logs.json");
    if (file.open(QIODevice::WriteOnly)) {
        QJsonDocument doc(m_activityLogs);
        file.write(doc.toJson());
        file.close();
    }
}

void GameEngine::exportData()
{
    saveLogs();
    qDebug() << "Data exported to activity_logs.json";
}
