#include "cognitive_engine.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <cmath>

CognitiveEngine::CognitiveEngine(QObject *parent) : QObject(parent) {
    m_sessionTimer.start();
    m_attentionTimestamps.append(0);
    m_attentionRatings.append(100.0);
    m_reactionLag = 0.0;
    m_spatialAccuracy = 100.0;
}

void CognitiveEngine::setPatientAge(int age) {
    if (m_patientAge != age) {
        m_patientAge = age;
        emit patientAgeChanged();
        
        // Recalculate cognitive fatigue with new age coefficient
        double ageCoeff = std::log(m_patientAge + 1.0);
        if (ageCoeff < 0.1) ageCoeff = 0.1;
        m_cognitiveFatigue = m_errorCount / (m_gridDimension * ageCoeff);
        emit cognitiveFatigueChanged();
    }
}

void CognitiveEngine::setGridDimension(int dim) {
    if (m_gridDimension != dim) {
        m_gridDimension = dim;
        emit gridDimensionChanged();
        
        // Recalculate related ratios
        double totalCells = m_gridDimension * m_gridDimension;
        m_trialAndErrorQuotient = m_errorCount / totalCells;
        emit trialAndErrorQuotientChanged();
        
        double ageCoeff = std::log(m_patientAge + 1.0);
        if (ageCoeff < 0.1) ageCoeff = 0.1;
        m_cognitiveFatigue = m_errorCount / (m_gridDimension * ageCoeff);
        emit cognitiveFatigueChanged();
    }
}

void CognitiveEngine::setActiveShapeMode(const QString &mode) {
    if (m_activeShapeMode != mode) {
        m_activeShapeMode = mode;
        emit activeShapeModeChanged();
    }
}

void CognitiveEngine::dispatchTelemetry(int pieceId, bool success) {
    qint64 offset = m_sessionTimer.elapsed();
    double totalCells = m_gridDimension * m_gridDimension;
    
    if (success) {
        m_successCount++;
        emit targetPlacedSuccess(pieceId);
        qDebug() << "[C++ Engine] Telemetry Snapped Piece ID:" << pieceId 
                 << "Offset ms:" << offset;
        
        // Puzzle completed: generate final clinical metrics structure
        if (m_successCount >= static_cast<int>(totalCells)) {
            compileFinalTelemetryJson();
        }
    } else {
        m_errorCount++;
        emit placementErrorRecorded(301);
        qDebug() << "[C++ Engine] Placement Error. Current mistakes count:" << m_errorCount;
        
        // 1. Calculate Impulsivity Index (Quotient of Trial & Error)
        m_trialAndErrorQuotient = static_cast<double>(m_errorCount) / totalCells;
        emit trialAndErrorQuotientChanged();
        
        // 2. Calculate Diagnostic Cognitive Fatigue Equation boundary threshold
        double ageCoeff = std::log(m_patientAge + 1.0);
        if (ageCoeff < 0.1) ageCoeff = 0.1;
        m_cognitiveFatigue = static_cast<double>(m_errorCount) / (m_gridDimension * ageCoeff);
        emit cognitiveFatigueChanged();
        
        // Alert interface if ADHD/executive fatigue threshold has crossed 1.0 critical limit
        if (m_cognitiveFatigue >= 1.0) {
            emit fatigueDetected(m_cognitiveFatigue);
        }
    }

    // Dynamic focus rating update (decreases with errors, latency, but can maintain stability)
    double calculatedFocus = 100.0 - (m_errorCount * 5.0) - (m_gatingRecoveryIndex > 0 ? (m_gatingRecoveryIndex / 200.0) : 0.0);
    if (calculatedFocus < 5.0) calculatedFocus = 5.0;
    if (m_focusRating != calculatedFocus) {
        m_focusRating = calculatedFocus;
        emit focusRatingChanged();
    }

    // Dynamic clumsiness index update (increases with motor jitter and mistakes)
    double calculatedClumsiness = (m_motorJitter * 8.0) + (m_totalDragLength > 0 ? (m_totalDragLength / 4000.0) : 0.0);
    if (m_errorCount > 0) {
        calculatedClumsiness += (static_cast<double>(m_errorCount) * 0.3);
    }
    if (m_clumsinessIndex != calculatedClumsiness) {
        m_clumsinessIndex = calculatedClumsiness;
        emit clumsinessIndexChanged();
    }

    // Dynamic spatial accuracy: decreases with coordinates motor jitter and impulsivity triggers
    double calculatedAccuracy = 100.0 - (m_motorJitter * 150.0) - (m_trialAndErrorQuotient * 45.0);
    if (calculatedAccuracy < 10.0) calculatedAccuracy = 10.0;
    if (calculatedAccuracy > 100.0) calculatedAccuracy = 100.0;
    if (m_spatialAccuracy != calculatedAccuracy) {
        m_spatialAccuracy = calculatedAccuracy;
        emit spatialAccuracyChanged();
    }

    // Reaction lag fallback calculation when no peripheral distraction gating reactions are registered
    if (m_reactionLag <= 0.0 && m_successCount > 0) {
        double calculatedLag = static_cast<double>(offset) / m_successCount;
        if (m_reactionLag != calculatedLag) {
            m_reactionLag = calculatedLag;
            emit reactionLagChanged();
        }
    }

    // Append data point for attention curve tracking over time
    m_attentionTimestamps.append(offset);
    m_attentionRatings.append(m_focusRating);
}

void CognitiveEngine::logDragEntropy(double velocity, double x, double y) {
    QPointF currentPoint(x, y);
    qint64 currentTime = m_sessionTimer.elapsed();
    
    if (!m_dragCoordinates.isEmpty()) {
        QPointF prevPoint = m_dragCoordinates.last();
        qint64 prevTime = m_dragTimestamps.last();
        
        double dist = std::hypot(currentPoint.x() - prevPoint.x(), currentPoint.y() - prevPoint.y());
        m_totalDragLength += dist;
        
        // Ensure no division by zero on timestamp delta
        double dt = (currentTime - prevTime) / 1000.0; // convert to seconds
        if (dt > 0.0) {
            double currentVelocity = dist / dt;
            
            // If we have previous coordinates, we calculate fine motor jitter indices: J_tremor = sum(|v_i+1 - v_i|) / D_total
            if (m_dragCoordinates.size() > 2) {
                // Calculate previous velocity for derivative acceleration delta
                QPointF priorPoint = m_dragCoordinates[m_dragCoordinates.size() - 2];
                qint64 priorTime = m_dragTimestamps[m_dragTimestamps.size() - 2];
                double priorDist = std::hypot(prevPoint.x() - priorPoint.x(), prevPoint.y() - priorPoint.y());
                double priorDt = (prevTime - priorTime) / 1000.0;
                
                if (priorDt > 0.0) {
                    double priorVelocity = priorDist / priorDt;
                    double accelerationDelta = std::abs(currentVelocity - priorVelocity);
                    
                    if (m_totalDragLength > 0.0) {
                        // Sum up acceleration perturbations
                        m_motorJitter += (accelerationDelta / m_totalDragLength);
                        emit motorJitterChanged();
                    }
                }
            }
        }
        
        // Alert warning debug stream on high micro-hesitation or tremors
        if (dist > 150.0) {
            qDebug() << "[C++ Clinical Telemetry] High-amplitude spatial jitter: " << x << "," << y;
        }
    }
    
    m_dragCoordinates.append(currentPoint);
    m_dragTimestamps.append(currentTime);
}

void CognitiveEngine::recordPeripheralDistractionReact(int delayMs) {
    m_gatingRecoveryIndex = static_cast<double>(delayMs);
    emit gatingRecoveryIndexChanged();
    
    if (m_reactionLag <= 0.1) {
        m_reactionLag = static_cast<double>(delayMs);
    } else {
        m_reactionLag = (m_reactionLag + static_cast<double>(delayMs)) / 2.0;
    }
    emit reactionLagChanged();
    
    qDebug() << "[C++ Diagnostic Engine] Distraction Recovery Gating Index:" 
             << m_gatingRecoveryIndex << "ms";
}

QString CognitiveEngine::compileFinalTelemetryJson() {
    QJsonObject root;
    root["patient_age"] = m_patientAge;
    root["grid_dimension"] = m_gridDimension;
    root["active_shape_mode"] = m_activeShapeMode;
    root["total_mistakes"] = m_errorCount;
    root["total_correct"] = m_successCount;
    root["session_duration_ms"] = static_cast<double>(m_sessionTimer.elapsed());
    root["motor_jitter_index"] = m_motorJitter;
    root["trial_and_error_quotient"] = m_trialAndErrorQuotient;
    root["gating_recovery_index_ms"] = m_gatingRecoveryIndex;
    root["cognitive_fatigue_threshold"] = m_cognitiveFatigue;
    root["average_focus_rating"] = m_focusRating;
    root["calculated_clumsiness_index"] = m_clumsinessIndex;
    root["average_reaction_lag_ms"] = m_reactionLag;
    root["spatial_accuracy_pct"] = m_spatialAccuracy;
    
    // Package continuous attention curve metrics over time
    QJsonArray curveArray;
    for (int i = 0; i < m_attentionTimestamps.size(); ++i) {
        QJsonObject pt;
        pt["elapsed_ms"] = static_cast<double>(m_attentionTimestamps[i]);
        pt["focus_rating"] = m_attentionRatings[i];
        curveArray.append(pt);
    }
    root["attention_curve"] = curveArray;
    
    QJsonDocument doc(root);
    QString jsonStr = doc.toJson(QJsonDocument::Compact);
    emit puzzleFinished(jsonStr);
    
    qDebug() << "[C++ Clinical Telemetry] Generated Final Diagnostic Records JSON:" << jsonStr;
    return jsonStr;
}
