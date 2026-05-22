#ifndef RECOGNITIONSHAPEEXPLORERDATASET_H
#define RECOGNITIONSHAPEEXPLORERDATASET_H

#include <QObject>
#include <QQmlEngine>
#include "../General/postactivity.h"
#include "../General/abstracterrorprocessing.h"

class RecognitionShapeExplorerDataset : public AbstractErrorProcessing
{
    Q_OBJECT
    QML_ELEMENT


public:
    explicit RecognitionShapeExplorerDataset(AbstractErrorProcessing *parent = nullptr);

signals:
};

#endif // RECOGNITIONSHAPEEXPLORERDATASET_H
