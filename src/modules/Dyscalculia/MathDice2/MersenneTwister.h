/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef MERSENNETWISTER_H
#define MERSENNETWISTER_H

#include <QObject>
#include <QVariantList>
#include <random>
#include <chrono>
#include <QQmlEngine>

class MersenneTwister : public QObject {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(quint32 seed READ seed WRITE setSeed NOTIFY seedChanged)

public:
    explicit MersenneTwister(QObject *parent = nullptr);

    // Roll a single die with given sides (e.g. 1-6)
    Q_INVOKABLE int rollDice(int sides);

    // Roll multiple dice and return them as a QVariantList for QML consumption
    Q_INVOKABLE QVariantList rollMany(int count, int sides);

    // Get standard random operations [+,-,*,/] for math problem formulation
    Q_INVOKABLE QString getRandomOperator(const QString &available);

    quint32 seed() const { return m_seed; }
    void setSeed(quint32 s);

signals:
    void seedChanged();

private:
    std::mt19937 m_generator;
    quint32 m_seed;
};

#endif // MERSENNETWISTER_H
