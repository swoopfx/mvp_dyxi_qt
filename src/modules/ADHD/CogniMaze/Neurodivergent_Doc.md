# ADHD CogniMaze Clinical & Technical Documentation

This project represents a highly optimized, low-distraction cognitive mapping game engineered specifically for children aged 4 to 7 with ADHD (Attention-Deficit/Hyperactivity Disorder). 

---

## 1. Neurodevelopmental Rationale
Children within this developmental bracket diagnosed with ADHD experience specific impairments in the brain's Executive Function Networks, primarily located in the Frontostriatal circuits. This leads to common behavioral traits including:

- **Sustained Attention Lapses**: Difficulty maintaining focus on goal-directed spatial tasks.
- **Micro-Impulsivity / Motor Rushing**: Boundary violations, rushing through paths, colliding with obstacles without calculating outcomes.
- **Working Memory Difficulties**: Failure to self-monitor coordinates, resulting in excessive backtracking or getting lost in simple layouts.

### How CogniMaze Helps
1. **Dynamic Spatial Recalibration**: Standard 2D grids (4x4 to 8x8) trigger immediate, interactive spatial challenge cycles. It strengthens visual-spatial working memory pipelines directly from the parietal to the prefrontal cortex.
2. **Immediate Auditory Reinforcement (Low-Distraction)**: Positive, soft acoustic chimes play on move success. Unlike flashing, overstimulating video games which trigger dopamine exhaustion, CogniMaze uses pastel, uniform layouts coupled with brief, calming harmonic cues. This balances the child's arousal patterns.
3. **Assessing Selective Distractibility**: By introducing controlled, subtle distractors (slow bubbles or butterflies) and measuring re-engagement latencies in the C++ engine, CogniMaze provides clinical indicators of attentional shifting without triggering stress.

---

## 2. Telemetry Parameters Map

| Attribute | C++ DataType | Cognitive / Clinical Biomarker Measured |
| :--- | :--- | :--- |
| `totalDurationSeconds` | `qint64` | Overall **Sustained Attention** capability. |
| `averageMoveDelayMs` | `double` | **Hesitation Index**: Measures motor preparation speed vs executive paralysis. |
| `wallCollisions` | `int` | **Motor Impulsivity / Rushing Index**: Touch speed exceeding spatial cognitive bounds. |
| `backtracksCount` | `int` | **Spatial Working Memory**: Inability to construct a cohesive mental map. |
| `averageReactionTimeMs` | `qint64` | **Attention Shift Threshold**: Speed of registering ambient peripheral visual events. |
| `averageRecoveryTimeMs` | `qint64` | **Executive Re-engagement Latency**: Time required to dismiss distraction and return to original goals. |
| `attentionFocusIndex` | `int (20-100)` | **Composite Spatial Focus Score**: Algorithmic weighting of efficiency, control, and poise. |

---

## 3. C++ Technical Architecture Benefit
By hosting compiling modules in **native C++**, the game benefits from:
- **Zero Garbage Collector Jitter**: Virtual Machines (such as JavaScript engines) undergo periodic garbage collection passes, causing minor frames-per-second micro-stuttering. ADHD children are incredibly sensitive to micro-stuttering, causing early frustration and focus breakage.
- **Hard Realtime Timers**: Native `QDateTime::currentMSecsSinceEpoch()` logs time deltas down to precision microseconds, ensuring reaction timing indicators are highly accurate.
- **Resilient Fallback Storage**: If the local network drops, the database handles errors via `QStandardPaths::writableLocation` and registers serialized streams into SQLite, ensuring data integrity.
