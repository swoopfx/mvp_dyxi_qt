#ifndef COGNITIVEENGINE_H
#define COGNITIVEENGINE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class CognitiveEngine : public QObject
{
    Q_OBJECT

public:
    explicit CognitiveEngine(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap calculateMetrics(const QVariantList &events, int age, int difficultyId) const;
    Q_INVOKABLE QString exportSessionToJson(const QVariantMap &sessionData) const;
};

#endif // COGNITIVEENGINE_H
