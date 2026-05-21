#include "networkaccesspresets.h"


NetworkAccessPresets::NetworkAccessPresets(QObject *parent)
    : AbstractErrorProcessing{parent}
{

}

QVariantMap NetworkAccessPresets::gameTypeIds() const
{
    return m_gameTypeIds;
}

void NetworkAccessPresets::setGameTypeIds(const QVariantMap &newGameTypeIds)
{
    if (m_gameTypeIds == newGameTypeIds)
        return;
    m_gameTypeIds = newGameTypeIds;
    emit gameTypeIdsChanged();
}
