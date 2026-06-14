# 🔬 Clinician Medical Records & Telemetry Algorithms

This manual defines the quantitative mathematical frameworks, metrics, and standard equations utilized by the **NeuroPlay** engine to monitor attention stability and cognitive fine motor control.

---

## 📐 1. Kinematic Motor Jitter & Tremor Index ($J_{tremor}$)
To track fine-motor coordination limits, coordination jitter is calculated during physical drag-and-drop operations on the puzzle pieces:

### Formula:
$$J_{tremor} = \frac{1}{D_{total}} \sum_{i=1}^{N-1} \left| \vec{v}_{i+1} - \vec{v}_i \right|$$

Where:
- $N$ is the total number of continuous coordinate drag points sampled.
- $\vec{v}_i$ is the instantaneous velocity vector between sample $i$ and $i+1$:
$$\vec{v}_i = \frac{\Delta \vec{d}_i}{\Delta t_i} = \left( \frac{x_{i+1} - x_i}{t_{i+1} - t_i}, \frac{y_{i+1} - y_i}{t_{i+1} - t_i} \right)$$
- $D_{total}$ is the absolute integrated distance of the drag path:
$$D_{total} = \sum_{i=1}^{N-1} \sqrt{(x_{i+1} - x_i)^2 + (y_{i+1} - y_i)^2}$$

### Clinical Evaluation:
- **Low Jitter ($J_{tremor} < 0.15$)**: Highly targeted, mature muscle control and steady trajectory.
- **High Jitter ($J_{tremor} \ge 0.40$)**: Indicates high directional correction, spatial hesitation, motor tremors, or motor planning deficits (e.g., developmental dyspraxia traits).

---

## 🎯 2. Impulsivity Metric & Trial-and-Error Quotient ($Q_{imp}$)
The target placement failure rate is translated to index spatial working memory lapses or impulsive click behavior.

### Formula:
$$Q_{imp} = \frac{E_{invalid}}{P_{total}}$$

Where:
- $E_{invalid}$ is the count of incorrect snap boundary attempts (failed target slots).
- $P_{total}$ is the total puzzle size ($GridSize^2$).

### Medical Interpretation:
- **High $Q_{imp}$ (\ge 1.5)**: Highly hyperactive or impulsive behavior. The subject engages in rapid trial-and-error snap attempts rather than deliberate spatial placement.
- **Low $Q_{imp}$ ($< 0.5$)**: High deliberate focus, planned motor placement.

---

## ⚡ 3. Sensory Gating & Distraction Recovery Index ($R_{gating}$)
This calculates raw auditory and visual attention recovery delays following a sudden peripheral distraction pop-up.

### Formula:
$$R_{gating} = T_{recovery} - T_{trigger}$$

Where:
- $T_{trigger}$ is the absolute Unix timestamp ($ms$) when the peripheral distraction event (clown visual, alarm sound) was injected.
- $T_{recovery}$ is the timestamp ($ms$) when the child successfully acknowledged or minimized the alarm, or successfully placed the next puzzle tile.

### Mathematical Standard Deviation Analysis:
We monitor the stability of recovery time using the standard coefficient of variation ($CV_{gating}$) across multiple distracted epochs:

$$CV_{gating} = \frac{\sigma_{gating}}{\mu_{gating}}$$

Where:
- $\sigma_{gating}$ is the standard deviation of recovery intervals.
- $\mu_{gating}$ is the mean recovery latency.

### Clinical Interpretation:
- **High $CV_{gating}$ (\ge 0.50)**: High variability in distraction impact, signaling variable cognitive gating (classic in ADHD/Inattentive subtypes).
- **Consistent $CV_{gating}$ ($< 0.20$)**: Solid filtering capabilities and smooth refocusing patterns.

---

## 📈 4. ADHD Cognitive Fatigue Threshold Equation ($F_{cog}$)
An dynamic error threshold marks progressive spatial-reasoning dropouts or sensory overload:

$$F_{cog} = \frac{E_{invalid}}{GridSize \times \text{AgeCoefficient}}$$

Where:
- $\text{AgeCoefficient}$ adjusts the expected failure boundaries based on pediatric age groups:
$$\text{AgeCoefficient} = \ln(\text{ChildAge} + 1)$$

If $F_{cog} \ge 1.0$, is triggered a recommended breaks routine representing cognitive exhaustion boundaries.

---

## 🎯 5. Focus Rating Calculation ($FR$)
The Focus Rating is a dynamic attention index (0-100%) that scales inversely with mistakes ($E_{invalid}$) and high sensory distraction reaction delay ($R_{gating}$):

$$FR = \max\left(5.0, 100.0 - (E_{invalid} \times 5.0) - \delta_{gating}\right)$$

Where:
- $\delta_{gating}$ is the gating latency penalty: if $R_{gating} > 0$, $\delta_{gating} = \frac{R_{gating}}{200.0}$, else $0.0$.

---

## 🏃 6. Clumsiness Index ($CI$)
The Clumsiness Index monitors physical dyspraxia characteristics and spatial tremors by integrating total relative drag length and derivative kinetic velocity fluctuations:

$$CI = (J_{tremor} \times 8.0) + \left(\frac{D_{total}}{4000.0}\right) + (E_{invalid} \times 0.3)$$

---

## 🧘 7. Reaction Gating Lags ($L_{react}$)
Reaction Gating Lags evaluate the delayed attention retrieval latency. It represents the mean elapsed time interval a patient takes to regain executive coordination post sensory distraction triggers, or the sequential placement intervals for jigsaw tiles:

$$L_{react} = \frac{1}{K} \sum_{k=1}^K I_{latency, k}$$

Where:
- $I_{latency, k}$ is the distraction recover delay, or the element snap time-span.
- $K$ is the recorded interaction count.

---

## 📐 8. Spatial Drag Accuracy ($SA$)
The Trajectory Spatial Accuracy tracks motor planning and spatial feedback loop optimization. The index measures line efficiency, penalizing unnecessary physical wandering, tremors, and misplaced attempts:

$$SA = \max\left(10.0, 100.0 - (J_{tremor} \times 150.0) - (Q_{imp} \times 45.0)\right)$$

Where:
- $J_{tremor}$ designates fine coordination velocity fluctuations.
- $Q_{imp}$ is the Trial-and-Error coordinates coefficient.

---

## 📁 9. Compiled JSON Record Schema
Upon completing all pieces, the C++ engine captures the complete high-resolution state and exports a raw medical-grade JSON object:

```json
{
  "patient_age": 7,
  "grid_dimension": 3,
  "active_shape_mode": "jigsaw",
  "total_mistakes": 2,
  "total_correct": 9,
  "session_duration_ms": 34502.0,
  "motor_jitter_index": 0.124,
  "trial_and_error_quotient": 0.222,
  "gating_recovery_index_ms": 420.0,
  "cognitive_fatigue_threshold": 0.321,
  "average_focus_rating": 87.9,
  "calculated_clumsiness_index": 1.592,
  "average_reaction_lag_ms": 1150.0,
  "spatial_accuracy_pct": 84.5,
  "attention_curve": [
    { "elapsed_ms": 0.0, "focus_rating": 100.0 },
    { "elapsed_ms": 14200.0, "focus_rating": 95.0 }
  ]
}
```
