#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QVariantList>
#include <QRandomGenerator>
#include <QDateTime>
#include "MetricsTracker.h"
#include "ActivityLogger.h"
#include <QQmlEngine>

class GameEngine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
    Q_PROPERTY(QString question READ question NOTIFY questionChanged)
    Q_PROPERTY(int targetValue READ targetValue NOTIFY questionChanged)
    Q_PROPERTY(QVariantList options READ options NOTIFY optionsChanged)

public:
    explicit GameEngine(MetricsTracker* metrics, ActivityLogger* logger, QObject *parent = nullptr)
        : QObject(parent), m_metrics(metrics), m_logger(logger), m_difficulty(1), m_targetValue(0) {
        generateTask();
    }

    int difficulty() const { return m_difficulty; }
    void setDifficulty(int d) { if(m_difficulty != d) { m_difficulty = d; emit difficultyChanged(); generateTask(); } }

    QString question() const { return m_question; }
    int targetValue() const { return m_targetValue; }
    QVariantList options() const { return m_options; }

    Q_INVOKABLE void submitAnswer(int value) {
        qint64 duration = QDateTime::currentMSecsSinceEpoch() - m_startTime;
        bool correct = (value == m_targetValue);
        
        m_metrics->recordAttempt(correct, duration);
        
        QJsonObject details;
        details["difficulty"] = m_difficulty;
        details["question"] = m_question;
        details["target"] = m_targetValue;
        details["answer"] = value;
        details["correct"] = correct;
        details["duration_ms"] = duration;
        m_logger->logEvent("submit_answer", details);

        if (correct) {
            emit answerCorrect();
            generateTask();
        } else {
            emit answerIncorrect();
        }
    }

    Q_INVOKABLE void generateTask() {
        m_startTime = QDateTime::currentMSecsSinceEpoch();
        int subTask = QRandomGenerator::global()->bounded(0, 2); // Variation within level

        if (m_difficulty == 1) { // Level 1: Simple Recognition & Matching
            if (subTask == 0) {
                m_targetValue = QRandomGenerator::global()->bounded(1, 11);
                m_question = QString("Find the Numicon for %1").arg(m_targetValue);
            } else {
                m_targetValue = QRandomGenerator::global()->bounded(1, 11);
                m_question = QString("Which one is the %1?").arg(m_targetValue);
            }
        } else if (m_difficulty == 2) { // Level 2: Addition & Comparison
            if (subTask == 0) {
                int a = QRandomGenerator::global()->bounded(1, 6);
                int b = QRandomGenerator::global()->bounded(1, 6);
                m_targetValue = a + b;
                m_question = QString("What is %1 + %2?").arg(a).arg(b);
            } else {
                int a = QRandomGenerator::global()->bounded(1, 10);
                m_targetValue = (a < 10) ? a + 1 : a - 1;
                m_question = QString("What is one more than %1?").arg(a);
            }
        } else { // Level 3: Number Bonds & Mental Math
            if (subTask == 0) {
                int a = QRandomGenerator::global()->bounded(1, 10);
                m_targetValue = 10 - a;
                // m_question = QString("What makes 10 with %1?").arg(a);
            } else {
                int a = QRandomGenerator::global()->bounded(5, 11);
                // int b = QRandomGenerator::global()->bounded(1, a);
                // m_targetValue = a - b;
                // m_question = QString("What is %1 - %2?").arg(a).arg(b);
            }
        }

        // Generate options (including correct one)
        QList<int> optList;
        // optList << m_targetValue;
        while(optList.size() < 4) {
            int val = QRandomGenerator::global()->bounded(1, 11);
            if(!optList.contains(val)) optList << val;
        }
        std::shuffle(optList.begin(), optList.end(), std::default_random_engine(m_startTime));
        
        m_options.clear();
        for(int v : optList) m_options << v;

        emit questionChanged();
        emit optionsChanged();
    }

signals:
    void difficultyChanged();
    void questionChanged();
    void optionsChanged();
    void answerCorrect();
    void answerIncorrect();

private:
    MetricsTracker* m_metrics;
    ActivityLogger* m_logger;
    int m_difficulty;
    int m_targetValue;
    QString m_question;
    QVariantList m_options;
    qint64 m_startTime;
};

#endif // GAMEENGINE_H
