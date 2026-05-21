#include "abstracterrorprocessing.h"

AbstractErrorProcessing::AbstractErrorProcessing(QObject *parent)
    : QObject{parent}
{}

bool AbstractErrorProcessing::isLoadingData() const
{
    return m_isLoadingData;
}

bool AbstractErrorProcessing::isLoadedData() const
{
    return m_isLoadedData;
}

void AbstractErrorProcessing::setIsLoadedData(bool newIsLoadedData)
{
    if (m_isLoadedData == newIsLoadedData)
        return;
    m_isLoadedData = newIsLoadedData;
    emit isLoadedDataChanged();
}
