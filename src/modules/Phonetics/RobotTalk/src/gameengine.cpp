#include "gameengine.h"
#include <QRandomGenerator>
#include <QUuid>
#include <QDateTime>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QHttpMultiPart>

GameEngine::GameEngine(QObject *parent) : QObject(parent) {
    m_tts = new QTextToSpeech(this);
    connect(m_tts, &QTextToSpeech::stateChanged, this, &GameEngine::handleSpeechStateChanged);
    m_sessionId = QUuid::createUuid().toString();
    selectRandomAnimal();
}

void GameEngine::selectRandomAnimal() {
    QStringList animals = {"hermit_crab", "cat", "dog"};
    m_currentAnimal = animals[QRandomGenerator::global()->bounded(animals.size())];
    emit currentAnimalChanged();
}

void GameEngine::startIntro() {
    replayIntro();
}

void GameEngine::replayIntro() {
    QString intro = QString("Hi I am %1, and I am happy to meet you. I would love to say these words with you, and I need your help to blend sounds together to make a word. I am trying to say something and I want to know what this word is. Lets blend this first word together.").arg(m_currentAnimal.replace("_", " "));
    m_tts->stop(); // Stop any current speech
    m_tts->setRate(0.6); // Read slow and precise
    m_tts->say(intro);
    m_isTalking = true;
    emit isTalkingChanged();
}

void GameEngine::handleSpeechStateChanged(QTextToSpeech::State state) {
    if (state == QTextToSpeech::Ready) {
        m_isTalking = false;
        emit isTalkingChanged();
        emit wordReadComplete();
    }
}

void GameEngine::startWordExercise(const QString &word) {
    // Logic for broken sounds /c/ - /a/ - /t/
    QString phonemes;
    for (int i = 0; i < word.length(); ++i) {
        phonemes += word[i];
        if (i < word.length() - 1) phonemes += " ... ";
    }
    m_tts->setRate(0.5);
    m_tts->say(phonemes);
    m_isTalking = true;
    emit isTalkingChanged();
}

void GameEngine::recordResponse(const QString &word, int attempt) {
    // Simulation of recording start
    qDebug() << "Recording response for word:" << word << "Attempt:" << attempt;
    
    // Simulate 2 second delay for recording
    QTimer::singleShot(2000, this, [this, word, attempt]() {
        QString fileName = QString("response_%1_%2_%3.wav").arg(m_sessionId).arg(word).arg(attempt);
        QVariantMap metric;
        metric["timeTaken"] = QRandomGenerator::global()->bounded(1500, 4000);
        metric["audioFile"] = fileName;
        metric["word"] = word;
        metric["attempt"] = attempt;
        metric["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
        m_metrics.append(metric);
        
        qDebug() << "Recording saved to:" << fileName;
        emit recordingComplete(fileName);
    });
}

void GameEngine::submitMetrics() {
    QJsonObject root;
    root["sessionId"] = m_sessionId;
    root["animal"] = m_currentAnimal;
    
    QJsonArray metricsArray;
    for (const auto &m : m_metrics) {
        metricsArray.append(QJsonObject::fromVariantMap(m));
    }
    root["metrics"] = metricsArray;
    
    // Calculated metrics
    root["fluencyIndex"] = calculateFluency();
    root["accuracy"] = calculateAccuracy();
    root["vocabularyKnowledge"] = 0.85; // Simulated
    root["memoryCapacity"] = 0.9; // Simulated
    
    QJsonDocument doc(root);
    QByteArray data = doc.toJson();
    
    // Simulate API Call
    qDebug() << "Submitting to API:" << data;
    
    // In a real app, use QNetworkAccessManager to POST to dummy endpoint
    emit apiResponse(true, "Data submitted successfully");
}

double GameEngine::calculateFluency() { return 0.75; }
double GameEngine::calculateAccuracy() { return 0.80; }
