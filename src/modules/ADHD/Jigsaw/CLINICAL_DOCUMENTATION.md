# 🧠 NeuroPlay: Medical & Clinical Documentation for Neurodivergent Children

## 📋 1. Medical App Overview
**NeuroPlay** is an interactive visual-spatial diagnostic and training simulator designed to gauge, monitor, and assist children with neurodevelopmental differences (specifically **ADHD**, **Autism Spectrum Condition (ASC)**, and other **Executive Function Deficits**). 

The platform leverages structural jigsaw puzzle mechanics, spatial tracking grids, and peripheral distraction stimulation triggers to assess cognitive endurance, motor coordination, fine motor tremor, and attention shifts in real-time.

---

## 🎯 2. How it Supports Neurodivergent Children
Children with ADHD or Autism often struggle with **spatial organization**, **peripheral sensory gating**, and **frustration tolerance**. NeuroPlay transforms these complex clinical assessments into an engaging, gamified simulator:
- **Low-Arousal UI & Gentle Audio Signals**: Eliminates clinical anxiety by using soft, soothing ambient colors (indigo, light grays) and high-quality, non-pulsing auditory responses.
- **Adjustable Cognitive Load**: Allows custom configuration of tile sizes and grid difficulty (2x2) based on child age/developmental profile.
- **Predictable Interaction Rules**: Simple drag-and-drop or horizontal tray selection mechanics reduce physical load, making interaction satisfying and highly structured.
- **Peripheral Calming System**: Includes visual pop-up distractions (clowns, balls, warning lights) designed to train the patient in "sensory filtering" (inhibiting response to non-target stimuli).

---

## 📊 3. Collected Parameters & Clinical Telemetry
The core C++ telemetry engine (`CognitiveEngine`) records and computes precise clinical metrics based on physical drag events and environmental markers:

| Parameter Channel | Unit of Metric | Medical/Cognitive Interpretation |
| :--- | :--- | :--- |
| **Snap Time Offset** | Milliseconds ($ms$) | Measures focus duration and processing speed from game start to successful target placement. |
| **Incorrect Snap Placements** | Count | Gauges impulsivity, trial-and-error behaviors, and rapid motor planning corrections. |
| **Fine-Motor Drag Jitter/Tremor** | Pixels / $ms$ | Tracks coordinate perturbation (jitter) during piece dragging. High values point to neurological motor hesitation, dyspraxia traits, or muscle tremors under fatigue. |
| **Response Reaction to Distractions** | Milliseconds ($ms$) | The delay before the patient recovers and clicks a peripheral distraction, highlighting auditory or visual sensory gating. |
| **ADHD Cognitive Fatigue Ratio** | Ratio ($e_c / N$) | Calculated as total failed attempts relative to grid dimensions. If the child exceeds 7 errors, a fatigue state is raised, suggesting intervention (sensory break). |

---

## 💡 4. Therapeutic & Spatial Benefits
1. **Executive Function Strengthening**: Enhances working memory and cognitive flexibility as the child holds visual target templates in mind during physical drag maneuvers.
2. **Fine-Motor Calibration**: Encourages delicate finger-eye feedback loops as pieces are carefully aligned and snapped into their respective vector locations.
3. **Selective Impulse Control**: Teaches clinical gating by encouraging patience and reducing rapid, uncalculated "slam placement" attempts on incorrect slot tiles.
4. **Actionable Clinical Tracking**: Provides parents and occupational therapists with quantitative telemetry instead of qualitative observations, detailing exactly when a child begins to experience fatigue.
