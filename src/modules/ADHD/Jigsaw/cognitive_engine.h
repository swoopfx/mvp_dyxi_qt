#ifndef COGNITIVE_ENGINE_H
#define COGNITIVE_ENGINE_H

#include <QObject>
#include <QJsonObject>
#include <QTimer>
#include <QElapsedTimer>
#include <QVector2D>
#include <QPointF>
#include <QList>
#include <QtQml>


class CognitiveEngine : public QObject {
    Q_OBJECT

    Q_PROPERTY(int patientAge READ patientAge WRITE setPatientAge NOTIFY patientAgeChanged)
    Q_PROPERTY(int gridDimension READ gridDimension WRITE setGridDimension NOTIFY gridDimensionChanged)
    Q_PROPERTY(QString activeShapeMode READ activeShapeMode WRITE setActiveShapeMode NOTIFY activeShapeModeChanged)
    
    // Clinical Diagnostic Telemetry Properties (Math Formulations)
    Q_PROPERTY(double motorJitter READ motorJitter NOTIFY motorJitterChanged)
    Q_PROPERTY(double trialAndErrorQuotient READ trialAndErrorQuotient NOTIFY trialAndErrorQuotientChanged)
    Q_PROPERTY(double gatingRecoveryIndex READ gatingRecoveryIndex NOTIFY gatingRecoveryIndexChanged)
    Q_PROPERTY(double cognitiveFatigue READ cognitiveFatigue NOTIFY cognitiveFatigueChanged)
    Q_PROPERTY(double focusRating READ focusRating NOTIFY focusRatingChanged)
    Q_PROPERTY(double clumsinessIndex READ clumsinessIndex NOTIFY clumsinessIndexChanged)
    Q_PROPERTY(double reactionLag READ reactionLag NOTIFY reactionLagChanged)
    Q_PROPERTY(double spatialAccuracy READ spatialAccuracy NOTIFY spatialAccuracyChanged)
    
    // Qt6 QML registration macro
    QML_ELEMENT

public:
    explicit CognitiveEngine(QObject *parent = nullptr);

    int patientAge() const { return m_patientAge; }
    void setPatientAge(int age);

    int gridDimension() const { return m_gridDimension; }
    void setGridDimension(int dim);

    QString activeShapeMode() const { return m_activeShapeMode; }
    void setActiveShapeMode(const QString &mode);

    // Getters for Clinical Telemetry
    double motorJitter() const { return m_motorJitter; }
    double trialAndErrorQuotient() const { return m_trialAndErrorQuotient; }
    double gatingRecoveryIndex() const { return m_gatingRecoveryIndex; }
    double cognitiveFatigue() const { return m_cognitiveFatigue; }
    double focusRating() const { return m_focusRating; }
    double clumsinessIndex() const { return m_clumsinessIndex; }
    double reactionLag() const { return m_reactionLag; }
    double spatialAccuracy() const { return m_spatialAccuracy; }

    // Dynamic invocations
    Q_INVOKABLE void dispatchTelemetry(int pieceId, bool success);
    Q_INVOKABLE void logDragEntropy(double velocity, double x, double y);
    Q_INVOKABLE void recordPeripheralDistractionReact(int delayMs);
    Q_INVOKABLE QString compileFinalTelemetryJson();

signals:
    void patientAgeChanged();
    void gridDimensionChanged();
    void activeShapeModeChanged();
    
    // Clinical Telemetry Signals
    void motorJitterChanged();
    void trialAndErrorQuotientChanged();
    void gatingRecoveryIndexChanged();
    void cognitiveFatigueChanged();
    void focusRatingChanged();
    void clumsinessIndexChanged();
    void reactionLagChanged();
    void spatialAccuracyChanged();
    
    void targetPlacedSuccess(int pieceId);
    void placementErrorRecorded(int errorCode);
    void fatigueDetected(double ratio);
    void puzzleFinished(const QString &telemetryJson);

private:
    int m_patientAge = 5;
    int m_gridDimension = 3;
    QString m_activeShapeMode = "jigsaw";
    
    // Clinical mathematical values
    double m_motorJitter = 0.0;
    double m_trialAndErrorQuotient = 0.0;
    double m_gatingRecoveryIndex = 0.0;
    double m_cognitiveFatigue = 0.0;
    double m_focusRating = 100.0;
    double m_clumsinessIndex = 0.0;
    double m_reactionLag = 0.0;
    double m_spatialAccuracy = 100.0;
    
    // Internal analytical properties
    QElapsedTimer m_sessionTimer;
    int m_errorCount = 0;
    int m_successCount = 0;
    QList<QPointF> m_dragCoordinates;
    QList<qint64> m_dragTimestamps;
    double m_totalDragLength = 0;

    // Attention curve tracking data points over time
    QList<qint64> m_attentionTimestamps;
    QList<double> m_attentionRatings;
};

#endif // COGNITIVE_ENGINE_H
