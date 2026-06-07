/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

#include "MersenneTwister.h"

MersenneTwister::MersenneTwister(QObject *parent) : QObject(parent) {
    // Generate high-resolution microsecond clock seed
    quint64 clockSeed = std::chrono::high_resolution_clock::now().time_since_epoch().count();
    m_seed = static_cast<quint32>(clockSeed);
    m_generator.seed(m_seed);
}

int MersenneTwister::rollDice(int sides) {
    if (sides <= 0) return 1;
    std::uniform_int_distribution<int> distribution(1, sides);
    return distribution(m_generator);
}

QVariantList MersenneTwister::rollMany(int count, int sides) {
    QVariantList results;
    if (count <= 0 || sides <= 0) return results;
    
    std::uniform_int_distribution<int> distribution(1, sides);
    for (int i = 0; i < count; ++i) {
        results.append(distribution(m_generator));
    }
    return results;
}

QString MersenneTwister::getRandomOperator(const QString &available) {
    if (available.isEmpty()) return "+";
    std::uniform_int_distribution<int> distribution(0, available.length() - 1);
    int idx = distribution(m_generator);
    return QString(available.at(idx));
}

void MersenneTwister::setSeed(quint32 s) {
    if (m_seed != s) {
        m_seed = s;
        m_generator.seed(s);
        emit seedChanged();
    }
}
