# Numicon Game C++ Backend Design

This document outlines the design for the core C++ backend components of the Numicon game, focusing on the `GameEngine`, `MetricsTracker`, and `ActivityLogger`.

## 1. GameEngine

The `GameEngine` class will be responsible for managing the game's state, generating challenges, and validating user interactions. It will expose properties and methods to the QML frontend for seamless integration.

### Key Responsibilities:
*   **Game State Management:** Track current level, task, and overall game progress.
*   **Challenge Generation:** Create Numicon-based problems for different difficulty levels (e.g., matching, ordering, number bonds, basic arithmetic).
*   **Input Validation:** Check if the user's interaction (e.g., placing a Numicon tile) is correct.
*   **Difficulty Scaling:** Adjust the complexity of challenges based on the player's performance and selected difficulty.
*   **QML Integration:** Expose game state and control methods via `Q_PROPERTY` and `Q_INVOKABLE`.

### Core Classes & Methods:

**`GameEngine.h`**

```cpp
#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QVariant>
#include <QTimer>
#include "MetricsTracker.h"
#include "ActivityLogger.h"

class GameEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentLevel READ currentLevel NOTIFY currentLevelChanged)
    Q_PROPERTY(QString currentTaskDescription READ currentTaskDescription NOTIFY currentTaskDescriptionChanged)
    Q_PROPERTY(QVariantList availableNumiconShapes READ availableNumiconShapes NOTIFY availableNumiconShapesChanged)
    Q_PROPERTY(QVariantList targetSlots READ targetSlots NOTIFY targetSlotsChanged)

public:
    explicit GameEngine(MetricsTracker* metricsTracker, ActivityLogger* activityLogger, QObject *parent = nullptr);

    int currentLevel() const { return m_currentLevel; }
    QString currentTaskDescription() const { return m_currentTaskDescription; }
    QVariantList availableNumiconShapes() const { return m_availableNumiconShapes; }
    QVariantList targetSlots() const { return m_targetSlots; }

public slots:
    void startGame(int difficulty);
    void submitAnswer(int shapeValue, int slotIndex);
    void nextTask();

signals:
    void currentLevelChanged();
    void currentTaskDescriptionChanged();
    void availableNumiconShapesChanged();
    void targetSlotsChanged();
    void taskCompleted(bool correct);
    void gameEnded();

private:
    void generateTask();
    void evaluateAnswer(int shapeValue, int slotIndex);

    int m_currentLevel;
    QString m_currentTaskDescription;
    QVariantList m_availableNumiconShapes; // e.g., list of int representing numicon values
    QVariantList m_targetSlots; // e.g., list of int representing target values for slots
    MetricsTracker* m_metricsTracker;
    ActivityLogger* m_activityLogger;
    QTimer m_taskTimer;
    qint64 m_taskStartTime;
};

#endif // GAMEENGINE_H
```

## 2. MetricsTracker

The `MetricsTracker` class will collect, store, and calculate various learning metrics. It will be a singleton or a globally accessible object to ensure consistent tracking across the game.

### Key Responsibilities:
*   **Data Collection:** Record raw events such as task start/end times, correct/incorrect attempts, and specific errors.
*   **Metric Calculation:** Compute derived metrics like accuracy, mental math speed, concentration (e.g., by analyzing response time variance), and frequency of interaction with certain numbers.
*   **Data Storage:** Temporarily store session metrics.
*   **QML Integration:** Provide read-only access to current session metrics for display in a dashboard.

### Core Classes & Methods:

**`MetricsTracker.h`**

```cpp
#ifndef METRICSTRACKER_H
#define METRICSTRACKER_H

#include <QObject>
#include <QDateTime>
#include <QMap>

class MetricsTracker : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double accuracy READ accuracy NOTIFY metricsUpdated)
    Q_PROPERTY(double mentalMathSpeed READ mentalMathSpeed NOTIFY metricsUpdated)
    Q_PROPERTY(int totalCorrect READ totalCorrect NOTIFY metricsUpdated)
    Q_PROPERTY(int totalFailed READ totalFailed NOTIFY metricsUpdated)

public:
    explicit MetricsTracker(QObject *parent = nullptr);

    void recordTaskStart();
    void recordTaskEnd(bool correct, qint64 durationMs, int difficulty, const QString& taskType, const QString& problem, const QString& userAnswer, const QString& correctAnswer);
    void resetSessionMetrics();

    double accuracy() const; // (totalCorrect / (totalCorrect + totalFailed))
    double mentalMathSpeed() const; // Average time per correct mental math task
    int totalCorrect() const { return m_totalCorrect; }
    int totalFailed() const { return m_totalFailed; }

signals:
    void metricsUpdated();

private:
    int m_totalCorrect;
    int m_totalFailed;
    QList<qint64> m_mentalMathTaskDurations; // For speed calculation
    QDateTime m_sessionStartTime;
    QMap<int, int> m_numiconFrequency; // How often each numicon is used/encountered
};

#endif // METRICSTRACKER_H
```

## 3. ActivityLogger

The `ActivityLogger` class will be responsible for logging every significant activity event in a JSON object. This log will be persistent and available for export.

### Key Responsibilities:
*   **Event Logging:** Capture detailed information about each game event (e.g., timestamp, event type, task details, user action, outcome).
*   **JSON Serialization:** Format all logged events as JSON objects.
*   **Persistent Storage:** Save logs to a file (e.g., `activity_log.json`) on the local filesystem.
*   **Data Retrieval:** Provide methods to retrieve the entire log or filtered portions.
*   **QML Integration:** Expose methods to request log data for display or export.

### Core Classes & Methods:

**`ActivityLogger.h`**

```cpp
#ifndef ACTIVITYLOGGER_H
#define ACTIVITYLOGGER_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QFile>
#include <QTextStream>

class ActivityLogger : public QObject
{
    Q_OBJECT
public:
    explicit ActivityLogger(const QString& logFilePath, QObject *parent = nullptr);

    void logEvent(const QString& eventType, const QJsonObject& details);
    QJsonArray getAllLogs() const; // For displaying/exporting all logs
    void clearLogs();

public slots:
    QString getLogsAsJsonString() const; // For QML to retrieve logs

signals:
    void newLogEntry(const QJsonObject& entry);

private:
    QString m_logFilePath;
    QJsonArray m_logEntries;

    void saveLogsToFile() const;
    void loadLogsFromFile();
};

#endif // ACTIVITYLOGGER_H
```

## QML-C++ Interaction

Both `GameEngine` and `MetricsTracker` will be exposed to QML as context properties using `QQmlApplicationEngine::rootContext()->setContextProperty()`. `ActivityLogger` will be used internally by `GameEngine` and `MetricsTracker`, but its `getLogsAsJsonString()` method will be exposed to QML for UI elements that allow viewing or exporting logs.

This design ensures a clear separation of concerns, with C++ handling the heavy computation, game logic, and data management, while QML provides a rich, animated, and graphical user interface.
