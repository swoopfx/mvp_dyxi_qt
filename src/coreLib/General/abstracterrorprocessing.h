#ifndef ABSTRACTERRORPROCESSING_H
#define ABSTRACTERRORPROCESSING_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>

class AbstractErrorProcessing : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("Error Processing Abstract Class ")

     Q_PROPERTY(bool isLoadingData READ isLoadingData  NOTIFY isLoadingDataChanged );
     Q_PROPERTY(bool isLoadedData READ isLoadedData WRITE setIsLoadedData NOTIFY isLoadedDataChanged)
public:
    explicit AbstractErrorProcessing(QObject *parent = nullptr);
    virtual  ~AbstractErrorProcessing()= default;
    // virtual void start() = 0;

    bool isLoadingData() const;

    bool isLoadedData() const;
    void setIsLoadedData(bool newIsLoadedData);

signals:
    void requestFailed(const QString &error);
    void requestFinished(const QString &response);

    void isLoadingDataChanged();
    void isLoadedDataChanged();

private:
    bool m_isLoadingData;
    bool m_isLoadedData;
};

#endif // ABSTRACTERRORPROCESSING_H
