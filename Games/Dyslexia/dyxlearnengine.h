#ifndef DYXLEARNENGINE_H
#define DYXLEARNENGINE_H

#include <QObject>
#include <QMap>

class DyxLearnEngine : public QObject
{
    Q_OBJECT
public:
    explicit DyxLearnEngine(QObject *parent = nullptr);

    Q_INVOKABLE void recordAnswer(QString letter , bool correct);
    Q_INVOKABLE QString  getNextLetter();

signals:

private:
    QMap<QString, int> mistakeTracker;
    QStringList  letter;
};

#endif // DYXLEARNENGINE_H
