#include "speechprocessor.h"
#include <QDebug>
#include <QDateTime>
#include <QNetworkRequest>
#include <QUrl>
#include <QHttpPart>
#include <QHttpMultiPart>
#include <QRandomGenerator>
#include <QTimer>


SpeechProcessor::SpeechProcessor(QObject *parent)
    : QObject(parent), m_sessionId("ses-qml-default"), m_audioSource(nullptr)
{
    m_networkManager = new QNetworkAccessManager(this);
    qDebug() << "C++ Whisper.cpp audio analyzer successfully mounted.";
}

SpeechProcessor::~SpeechProcessor()
{
}

void SpeechProcessor::startRecording(const QString &fileName)
{
    m_currentFileName = fileName + ".raw";
    m_tempFile.setFileName(m_currentFileName);
    
    if (!m_tempFile.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        emit recordingFailed("Could not write record to directory stream file.");
        return;
    }

    qDebug() << "C++ micro recorder started on: " << m_currentFileName;
    
    // Config Qt Audio format suitable for local pocket Whisper.cpp (16000Hz, 1Channel, Mono 16-bit)
    QAudioFormat format;
    format.setSampleRate(16000);
    format.setChannelCount(1);
    format.setSampleFormat(QAudioFormat::Int16);

    m_audioSource = new QAudioSource(format, this);
    m_audioSource->start(&m_tempFile);
}

void SpeechProcessor::stopAndAnalyze(const QString &expectedWord, qint64 timeTakenMs)
{
    if (m_audioSource) {
        m_audioSource->stop();
        m_tempFile.close();
        m_audioSource->deleteLater();
        m_audioSource = nullptr;
    }

    qDebug() << "C++ Recording stopped. Audio saved. Heavy computational diagnostics initialized.";

    // Simulating Local-First Whisper.cpp decoding speech output!
    // Kids occasionally swap vowels or stutter slightly, e.g. "KA-AT" or "DA-AG"
    QString spokenPhonetics = expectedWord; // simulated match
    if (QRandomGenerator::global()->generateDouble() > 0.85) {
        spokenPhonetics = (expectedWord == "DOG") ? "DOGGIE" : expectedWord + "E"; // simulated phoneme shift mismatch
    }

    // Heavy Metrics Calculations (C++ Exclusive Algorithm)
    int accuracy = calculateSpellAccuracy(expectedWord, spokenPhonetics);
    int fluency = computeFluencyIndex(timeTakenMs, accuracy);
    int vocab = computeVocabularyScore(m_sessionId, expectedWord);
    int memory = computeMemoryCapacity(expectedWord, timeTakenMs);
    int consistency = computePhonicConsistency(expectedWord, accuracy);
    double speechRate = computeSpeechRate(expectedWord, timeTakenMs);
    QString pGrade = computePronunciationGrade(accuracy, expectedWord.length());

    // Form Event Json Packet
    QJsonObject activityMetrics;
    activityMetrics["sessionId"] = m_sessionId;
    activityMetrics["wordSpoken"] = spokenPhonetics;
    activityMetrics["expectedWord"] = expectedWord;
    activityMetrics["timeTakenToRespond"] = static_cast<double>(timeTakenMs);
    activityMetrics["accuracy"] = accuracy;
    activityMetrics["fluencyIndex"] = fluency;
    activityMetrics["vocabularyKnowledge"] = vocab;
    activityMetrics["memoryCapacity"] = memory;
    activityMetrics["phonicConsistency"] = consistency;
    activityMetrics["speechRate"] = speechRate;
    activityMetrics["pronunciationGrade"] = pGrade;
    activityMetrics["audioFileName"] = m_currentFileName;
    activityMetrics["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);

    m_activitiesArray.append(activityMetrics);

    // Save Event Log
    QJsonObject eventLog;
    eventLog["id"] = QString::number(QDateTime::currentMSecsSinceEpoch());
    eventLog["sessionId"] = m_sessionId;
    eventLog["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    eventLog["eventType"] = "API_SYNC_START";
    eventLog["details"] = QString("C++ phonetic match [Acc: %1%, Fluency: %2%, Consistency: %3%, Grade: %4%]").arg(accuracy).arg(fluency).arg(consistency).arg(pGrade);
    m_eventHistory.append(eventLog);

    // Prepare HTTP Multipart POST payload to remote analytics repository
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType, this);

    // JSON portion
    QHttpPart jsonPart;
    jsonPart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("application/json"));
    jsonPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"metrics\""));
    QJsonDocument doc(activityMetrics);
    jsonPart.setBody(doc.toJson());
    multiPart->append(jsonPart);

    // Send mock POST variable file stream
    QHttpPart audioPart;
    audioPart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("audio/wave"));
    audioPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant(QString("form-data; name=\"audioFile\"; filename=\"%1\"").arg(m_currentFileName)));
    
    QFile *file = new QFile(m_currentFileName);
    file->open(QIODevice::ReadOnly);
    file->setParent(multiPart); // will be deleted when multiPart is deleted
    audioPart.setBodyDevice(file);
    multiPart->append(audioPart);

    QUrl url("http://localhost:3000/api/metrics");
    QNetworkRequest request(url);
    
    QNetworkReply *reply = m_networkManager->post(request, multiPart);
    multiPart->setParent(reply); // delete multipart with reply

    connect(reply, &QNetworkReply::finished, this, &SpeechProcessor::handleUploadFinished);

    // Emit back parameters to QML UI for immediate kid feedback
    emit speechEvaluationCompleted(accuracy, fluency, vocab, memory, consistency, speechRate, pGrade, doc.toJson(QJsonDocument::Compact));
}

int SpeechProcessor::calculateSpellAccuracy(const QString &expected, const QString &spoken)
{
    // Levenshtein phonetic distance calculator
    QString ex = expected.trimmed().toUpper();
    QString sp = spoken.trimmed().toUpper();

    if (ex == sp) return 100;
    if (ex.isEmpty() || sp.isEmpty()) return 0;

    int n = ex.length();
    int m = sp.length();
    QVector<QVector<int>> dp(n + 1, QVector<int>(m + 1, 0));

    for (int i = 0; i <= n; ++i) dp[i][0] = i;
    for (int j = 0; j <= m; ++j) dp[0][j] = j;

    for (int i = 1; i <= n; ++i) {
        for (int j = 1; j <= m; ++j) {
            int cost = (ex[i-1] == sp[j-1]) ? 0 : 1;
            dp[i][j] = qMin(qMin(dp[i-1][j] + 1, dp[i][j-1] + 1), dp[i-1][j-1] + cost);
        }
    }

    int distance = dp[n][m];
    int maxL = qMax(n, m);
    int score = ((maxL - distance) * 100) / maxL;
    return qMax(0, score);
}

int SpeechProcessor::computeFluencyIndex(qint64 timeTakenMs, int accuracy)
{
    // High performance on 3s mark, diminished on longer delays
    double seconds = timeTakenMs / 1000.0;
    if (seconds < 0.2) seconds = 1.5; // safety guard
    int fluency = 95 - static_cast<int>(seconds * 6.5);
    if (accuracy > 85) fluency += 8;
    return qMax(10, qMin(100, fluency));
}

int SpeechProcessor::computeVocabularyScore(const QString &session, const QString &word)
{
    Q_UNUSED(session);
    // Counts unique success cases mapped in C++ from m_activitiesArray
    QSet<QString> uniqueWords;
    uniqueWords.insert(word);
    
    for (int i = 0; i < m_activitiesArray.count(); ++i) {
        QJsonObject obj = m_activitiesArray.at(i).toObject();
        if (obj["accuracy"].toInt() >= 70) {
            uniqueWords.insert(obj["expectedWord"].toString());
        }
    }
    
    // Scale count: e.g. 1 success = 30%, 2 = 50%, 3 = 70%, 4+ = 85%+
    int count = uniqueWords.count();
    int vocab = 30 + (count * 15);
    return qMin(100, vocab);
}

int SpeechProcessor::computeMemoryCapacity(const QString &word, qint64 currentTimingMs)
{
    // Checks how reaction times evaluate when reading same words repeatedly
    qint64 lastTiming = 0;
    for (int i = m_activitiesArray.count() - 1; i >= 0; --i) {
        QJsonObject obj = m_activitiesArray.at(i).toObject();
        if (obj["expectedWord"].toString() == word) {
            lastTiming = static_cast<qint64>(obj["timeTakenToRespond"].toDouble());
            break;
        }
    }

    int baseMemory = 75;
    if (lastTiming > 0) {
        qint64 speedup = lastTiming - currentTimingMs;
        if (speedup > 150) { // faster retrieval in memory
            baseMemory = 92;
        } else if (speedup < -300) { // slower recall
            baseMemory = 60;
        } else {
            baseMemory = 80;
        }
    }
    return baseMemory;
}

int SpeechProcessor::computePhonicConsistency(const QString &word, int currentAccuracy)
{
    // Standard deviation or similarity of accuracy across repeated trials of the exact same sound
    QVector<int> previousAccuracies;
    for (int i = 0; i < m_activitiesArray.count(); ++i) {
        QJsonObject obj = m_activitiesArray.at(i).toObject();
        if (obj["expectedWord"].toString() == word) {
            previousAccuracies.append(obj["accuracy"].toInt());
        }
    }

    if (previousAccuracies.isEmpty()) {
        return 90; // baseline consistency for first run
    }

    previousAccuracies.append(currentAccuracy);
    
    // Calculate mean
    double sum = 0;
    for (int acc : previousAccuracies) sum += acc;
    double mean = sum / previousAccuracies.count();

    // Calculate variance
    double variance = 0;
    for (int acc : previousAccuracies) {
        variance += qPow(acc - mean, 2);
    }
    variance /= previousAccuracies.count();

    // Higher variance means lower stability/consistency
    double stddev = qSqrt(variance);
    int consistency = 100 - static_cast<int>(stddev * 1.5);
    return qMax(30, qMin(100, consistency));
}

double SpeechProcessor::computeSpeechRate(const QString &word, qint64 timeTakenMs)
{
    // Count syllables or letters uttered divided by time duration in seconds
    double seconds = timeTakenMs / 1000.0;
    if (seconds <= 0.3) seconds = 0.3; // guard division by zero
    
    // Syllables roughly approximated by letters
    double characters = static_cast<double>(word.length());
    double rate = characters / seconds; // chars per second
    // Standardize to double formatted to 2 decimals
    return qMin(12.0, qMax(0.2, rate));
}

QString SpeechProcessor::computePronunciationGrade(int accuracy, int difficulty)
{
    if (accuracy >= 95) {
         return (difficulty >= 4) ? "PERFECT_EXPERT" : "PERFECT_BASIC";
    } else if (accuracy >= 80) {
         return "EXCELLENT_FLOW";
    } else if (accuracy >= 65) {
         return "APPROACHING_MASTERY";
    } else {
         return "PRACTICE_NEEDED";
    }
}

void SpeechProcessor::resetSession()
{
    m_activitiesArray = QJsonArray();
    m_eventHistory = QJsonArray();
    
    QJsonObject resetLog;
    resetLog["id"] = QString::number(QDateTime::currentMSecsSinceEpoch());
    resetLog["sessionId"] = m_sessionId;
    resetLog["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    resetLog["eventType"] = "APP_LOAD";
    resetLog["details"] = "Session memory registers cleared inside C++ backend storage.";
    m_eventHistory.append(resetLog);
    
    qDebug() << "C++ Session Activities and event registers cleared.";
}

QString SpeechProcessor::exportSessionSummaryJson()
{
    QJsonObject summary;
    summary["sessionId"] = m_sessionId;
    summary["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    summary["developerNote"] = "Qt6 QML Word Recognition Project Exported Metrics Packet";
    
    int totalCount = m_activitiesArray.count();
    summary["totalWordsTested"] = totalCount;

    // Calculate Session Average Statistics
    double accuracyAccumulator = 0.0;
    double fluencyAccumulator = 0.0;
    double vocabularyAccumulator = 0.0;
    double memoryAccumulator = 0.0;
    double consistencyAccumulator = 0.0;
    double speechRateAccumulator = 0.0;

    for (int i = 0; i < totalCount; ++i) {
        QJsonObject obj = m_activitiesArray.at(i).toObject();
        accuracyAccumulator += obj["accuracy"].toInt();
        fluencyAccumulator += obj["fluencyIndex"].toInt();
        vocabularyAccumulator += obj["vocabularyKnowledge"].toInt();
        memoryAccumulator += obj["memoryCapacity"].toInt();
        consistencyAccumulator += obj["phonicConsistency"].toInt();
        speechRateAccumulator += obj["speechRate"].toDouble();
    }

    summary["avgAccuracy"] = (totalCount > 0) ? (accuracyAccumulator / totalCount) : 0.0;
    summary["avgFluencyIndex"] = (totalCount > 0) ? (fluencyAccumulator / totalCount) : 0.0;
    summary["avgVocabularyScore"] = (totalCount > 0) ? (vocabularyAccumulator / totalCount) : 0.0;
    summary["avgMemoryCapacity"] = (totalCount > 0) ? (memoryAccumulator / totalCount) : 0.0;
    summary["avgPhonicConsistency"] = (totalCount > 0) ? (consistencyAccumulator / totalCount) : 0.0;
    summary["avgSpeechRateCharsPerSec"] = (totalCount > 0) ? (speechRateAccumulator / totalCount) : 0.0;

    // Nest historical vectors
    summary["individualTrials"] = m_activitiesArray;
    summary["systemEventAuditLogs"] = m_eventHistory;

    QJsonDocument doc(summary);
    return doc.toJson(QJsonDocument::Indented);
}

void SpeechProcessor::handleUploadFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply) {
        if (reply->error() == QNetworkReply::NoError) {
            qDebug() << "C++ Audio posted successfully to remote Node Endpoint. Code status: OK";
        } else {
            qDebug() << "Post Upload failure block: " << reply->errorString();
            emit recordingFailed("Upload-Error: Network connection terminated.");
        }
        reply->deleteLater();
    }
}

void SpeechProcessor::handleUploadError(QNetworkReply::NetworkError code)
{
    qDebug() << "C++ Network upload error occurred with code: " << code;
}

void SpeechProcessor::speak(const QString &text)
{
    qDebug() << "C++ Backend Speech Engine synthesizing TTS stream:" << text;
    // Calculate simulated delay based on length of the sentence (approx 75ms per char, min 1200ms)
    int delayMs = qMax(1200, text.length() * 75);
    QTimer::singleShot(delayMs, this, &SpeechProcessor::ttsPlayFinished);
}

