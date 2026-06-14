#include "cognitiveengine.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <cmath>

CognitiveEngine::CognitiveEngine(QObject *parent)
    : QObject(parent)
{
}

QVariantMap CognitiveEngine::calculateMetrics(const QVariantList &events, int age, int difficultyId) const
{
    QVariantMap results;

    int rtsCount = 0;
    double sumRTs = 0.0;
    double sumSqDiffs = 0.0;
    int hitsCount = 0;
    int regularHits = 0;
    int goldenHits = 0;
    int falseHitsCute = 0;
    int falseHitsBomb = 0;
    int totalSpawns = 0;
    int blankClicks = 0;

    QList<double> rtsList;

    for (const QVariant &v : events) {
        QVariantMap event = v.toMap();
        QString type = event.value("type").toString();
        QString moleType = event.value("moleType").toString();
        double durationSinceSpawn = event.value("durationSinceSpawn").toDouble();

        if (type == "SPAWN") {
            totalSpawns++;
        } else if (type == "BLANK_CLICK") {
            blankClicks++;
        } else if (type == "HIT") {
            hitsCount++;
            rtsCount++;
            sumRTs += durationSinceSpawn;
            rtsList.append(durationSinceSpawn);

            if (moleType == "REGULAR_MOLE") regularHits++;
            else if (moleType == "GOLDEN_MOLE") goldenHits++;
            else if (moleType == "DISTRACTOR_CUTE") falseHitsCute++;
            else if (moleType == "DISTRACTOR_BOMB") falseHitsBomb++;
        }
    }

    double speedIndex = 0.0;
    if (rtsCount > 0) {
        speedIndex = sumRTs / rtsCount;
        double mean = speedIndex;
        for (double rt : rtsList) {
            sumSqDiffs += std::pow(rt - mean, 2);
        }
    }

    double rtConsistency = 100.0;
    if (rtsCount > 1) {
        double variance = sumSqDiffs / (rtsCount - 1);
        double stdDev = std::sqrt(variance);
        double cv = stdDev / speedIndex;
        rtConsistency = std::max(0.0, 100.0 - (cv * 100.0));
    }

    double targetAccuracy = (totalSpawns > 0) ? (static_cast<double>(regularHits + goldenHits) / totalSpawns) * 100.0 : 0.0;
    double sustainedAttention = targetAccuracy * (rtConsistency / 100.0);
    double distractibilityIndex = (totalSpawns > 0) ? (static_cast<double>(falseHitsCute) / totalSpawns) * 100.0 : 0.0;
    double impulsivityIndex = (totalSpawns > 0) ? (static_cast<double>(falseHitsBomb) / totalSpawns) * 100.0 : 0.0;
    double adhdProbability = (distractibilityIndex * 0.4) + (impulsivityIndex * 0.4) + ((100.0 - rtConsistency) * 0.2);

    // Dynamic Cognitive Score & Stability Index calculation
    double accuracyVec = (totalSpawns > 0) ? (static_cast<double>(regularHits + goldenHits) / totalSpawns) * 100.0 : 100.0;
    double impulseCtrl = 100.0 - distractibilityIndex - impulsivityIndex;
    if (impulseCtrl < 0.0) impulseCtrl = 0.0;
    double speedFactor = 100.0;
    if (speedIndex > 0) {
        speedFactor = std::max(0.0, std::min(100.0, 100.0 - ((speedIndex - 300.0) / 9.0)));
    }
    double cognitiveScore = (impulseCtrl * 0.35) + (rtConsistency * 0.25) + (accuracyVec * 0.25) + (speedFactor * 0.15);
    cognitiveScore = std::max(0.0, std::min(100.0, cognitiveScore));

    double stabilityIndex = rtConsistency;

    results.insert("rtConsistency", rtConsistency);
    results.insert("speedIndex", speedIndex);
    results.insert("sustainedAttention", sustainedAttention);
    results.insert("distractibilityIndex", distractibilityIndex);
    results.insert("impulsivityIndex", impulsivityIndex);
    results.insert("adhdProbability", adhdProbability);
    results.insert("cognitiveScore", cognitiveScore);
    results.insert("stabilityIndex", stabilityIndex);
    results.insert("totalSpawns", totalSpawns);
    results.insert("regularHits", regularHits);
    results.insert("goldenHits", goldenHits);
    results.insert("falseHitsCute", falseHitsCute);
    results.insert("falseHitsBomb", falseHitsBomb);

    return results;
}

QString CognitiveEngine::exportSessionToJson(const QVariantMap &sessionData) const
{
    QJsonObject obj = QJsonObject::fromVariantMap(sessionData);
    QJsonDocument doc(obj);
    return doc.toJson(QJsonDocument::Indented);
}
