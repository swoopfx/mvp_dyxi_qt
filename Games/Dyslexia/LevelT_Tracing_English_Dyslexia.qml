import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Particles 2.15
// import QtTextToSpeech 2.15

ApplicationWindow {
    id: root
    width: 900
    height: 700
    visible: true
    title: "Alphabet Tracer - Dyslexia Friendly"
    color: "#FDF6E3" // Soft pastel yellow/white to reduce visual stress

    // --- State Properties ---
    property int currentLevel: 0
    property var activeWaypoints:[]
    property int currentStrokeIndex: 0
    property int currentPointIndex: 0
    property bool levelFinished: false

    // --- Audio Engine ---
    // TextToSpeech {
    //     id: tts
    //     volume: 1.0
    // }

    // --- Level & Word Data ---
    property var levelData:[
        { letter: 'A', word: 'Apple', emoji: '🍎' }, { letter: 'B', word: 'Ball', emoji: '⚽' },
        { letter: 'C', word: 'Cat', emoji: '🐱' }, { letter: 'D', word: 'Dog', emoji: '🐶' },
        { letter: 'E', word: 'Elephant', emoji: '🐘'}, { letter: 'F', word: 'Fish', emoji: '🐟' },
        { letter: 'G', word: 'Goat', emoji: '🐐' }, { letter: 'H', word: 'Hat', emoji: '🎩' },
        { letter: 'I', word: 'Ice Cream', emoji: '🍦'},{ letter: 'J', word: 'Juice', emoji: '🧃' },
        { letter: 'K', word: 'Kite', emoji: '🪁' }, { letter: 'L', word: 'Lion', emoji: '🦁' },
        { letter: 'M', word: 'Monkey', emoji: '🐵' }, { letter: 'N', word: 'Nest', emoji: '🪹' },
        { letter: 'O', word: 'Orange', emoji: '🍊' }, { letter: 'P', word: 'Pig', emoji: '🐷' },
        { letter: 'Q', word: 'Queen', emoji: '👑' }, { letter: 'R', word: 'Rabbit', emoji: '🐰' },
        { letter: 'S', word: 'Sun', emoji: '☀️' }, { letter: 'T', word: 'Tree', emoji: '🌳' },
        { letter: 'U', word: 'Umbrella', emoji: '☂️'}, { letter: 'V', word: 'Van', emoji: '🚐' },
        { letter: 'W', word: 'Water', emoji: '💧' }, { letter: 'X', word: 'Xylophone', emoji: '🎹'},
        { letter: 'Y', word: 'Yoyo', emoji: '🪀' }, { letter: 'Z', word: 'Zebra', emoji: '🦓' }
    ]

    // Automatically Generated Raw Stroke Points (Normalized 0.0 to 1.0)
    // Structured as [ [Stroke1_Points],[Stroke2_Points] ]
    property var letterStrokes: {
        'A': [[[0.5,0.1],[0.2,0.9]], [[0.5,0.1],[0.8,0.9]], [[0.35,0.6],[0.65,0.6]]],
        'B': [[[0.3,0.1],[0.3,0.9]], [[0.3,0.1],[0.7,0.1],[0.8,0.3],[0.7,0.5],[0.3,0.5]], [[0.3,0.5],[0.7,0.5],[0.8,0.7],[0.7,0.9],[0.3,0.9]]],
        'C': [[[0.8,0.2],[0.6,0.1],[0.4,0.1],[0.2,0.3],[0.2,0.7],[0.4,0.9],[0.6,0.9],[0.8,0.8]]],
        'D': [[[0.3,0.1],[0.3,0.9]], [[0.3,0.1],[0.7,0.1],[0.85,0.3],[0.85,0.7],[0.7,0.9],[0.3,0.9]]],
        'E': [[[0.8,0.1],[0.3,0.1],[0.3,0.9],[0.8,0.9]], [[0.3,0.5],[0.7,0.5]]],
        'F': [[[0.8,0.1],[0.3,0.1],[0.3,0.9]], [[0.3,0.5],[0.65,0.5]]],
        'G': [[[0.8,0.2],[0.6,0.1],[0.3,0.2],[0.2,0.5],[0.3,0.8],[0.6,0.9],[0.8,0.7],[0.8,0.5],[0.5,0.5]]],
        'H': [[[0.3,0.1],[0.3,0.9]], [[0.7,0.1],[0.7,0.9]], [[0.3,0.5],[0.7,0.5]]],
        'I': [[[0.5,0.1],[0.5,0.9]], [[0.3,0.1],[0.7,0.1]], [[0.3,0.9],[0.7,0.9]]],
        'J': [[[0.7,0.1],[0.7,0.8],[0.5,0.9],[0.3,0.8],[0.3,0.7]]],
        'K': [[[0.3,0.1],[0.3,0.9]], [[0.7,0.1],[0.3,0.5]], [[0.3,0.5],[0.7,0.9]]],
        'L': [[[0.3,0.1],[0.3,0.9],[0.7,0.9]]],
        'M': [[[0.2,0.9],[0.2,0.1],[0.5,0.5],[0.8,0.1],[0.8,0.9]]],
        'N': [[[0.2,0.9],[0.2,0.1],[0.8,0.9],[0.8,0.1]]],
        'O': [[[0.5,0.1],[0.2,0.3],[0.2,0.7],[0.5,0.9],[0.8,0.7],[0.8,0.3],[0.5,0.1]]],
        'P': [[[0.3,0.9],[0.3,0.1],[0.7,0.1],[0.8,0.3],[0.7,0.5],[0.3,0.5]]],
        'Q': [[[0.5,0.1],[0.2,0.3],[0.2,0.7],[0.5,0.9],[0.8,0.7],[0.8,0.3],[0.5,0.1]], [[0.6,0.6],[0.9,0.9]]],
        'R': [[[0.3,0.9],[0.3,0.1],[0.7,0.1],[0.8,0.3],[0.7,0.5],[0.3,0.5]], [[0.5,0.5],[0.8,0.9]]],
        'S': [[[0.8,0.2],[0.5,0.1],[0.3,0.2],[0.3,0.4],[0.5,0.5],[0.7,0.6],[0.7,0.8],[0.5,0.9],[0.2,0.8]]],
        'T': [[[0.2,0.1],[0.8,0.1]], [[0.5,0.1],[0.5,0.9]]],
        'U': [[[0.2,0.1],[0.2,0.7],[0.5,0.9],[0.8,0.7],[0.8,0.1]]],
        'V': [[[0.2,0.1],[0.5,0.9],[0.8,0.1]]],
        'W': [[[0.1,0.1],[0.3,0.9],[0.5,0.5],[0.7,0.9],[0.9,0.1]]],
        'X': [[[0.2,0.1],[0.8,0.9]], [[0.8,0.1],[0.2,0.9]]],
        'Y': [[[0.2,0.1],[0.5,0.5]], [[0.8,0.1],[0.5,0.5]], [[0.5,0.5],[0.5,0.9]]],
        'Z': [[[0.2,0.1],[0.8,0.1],[0.2,0.9],[0.8,0.9]]]
    }

    // --- Core Logic ---
    function loadLevel() {
        levelFinished = false;
        currentStrokeIndex = 0;
        currentPointIndex = 0;

        let data = levelData[currentLevel];
        let raw = letterStrokes[data.letter];

        // Path generation (Interpolation for dense accuracy tracking)
        activeWaypoints =[];
        for (let i = 0; i < raw.length; i++) {
            let stroke = raw[i];
            let pts =[];
            for (let j = 0; j < stroke.length - 1; j++) {
                let p1 = stroke[j];
                let p2 = stroke[j+1];
                let dist = Math.hypot(p2[0]-p1[0], p2[1]-p1[1]);
                let steps = Math.max(2, Math.ceil(dist / 0.03)); // Create dense waypoints
                for (let k = 0; k < steps; k++) {
                    pts.push([ p1[0] + (p2[0]-p1[0])*(k/steps), p1[1] + (p2[1]-p1[1])*(k/steps) ]);
                }
            }
            pts.push(stroke[stroke.length-1]);
            activeWaypoints.push(pts);
        }

        drawCanvas.requestPaint();
        tts.say(data.letter + " ... for " + data.word);
    }

    function completeLevel() {
        levelFinished = true;
        confettiEmitter.burst(150);
        tts.say("Great job! " + levelData[currentLevel].letter + " for " + levelData[currentLevel].word);

        nextLevelTimer.start();
    }

    Timer {
        id: nextLevelTimer
        interval: 3500
        onTriggered: {
            currentLevel = (currentLevel + 1) % levelData.length;
            loadLevel();
        }
    }

    Component.onCompleted: loadLevel()

    // --- UI Elements ---
    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        // Header Panel
        Rectangle {
            width: parent.width
            height: 100
            radius: 20
            color: "#FFFFFF"
            border.color: "#E0E0E0"
            border.width: 3

            Row {
                anchors.centerIn: parent
                spacing: 20
                Text {
                    text: levelData[currentLevel].letter + " for " + levelData[currentLevel].word
                    font.pixelSize: 48
                    font.bold: true
                    font.family: "Comic Sans MS" // Highly readable for dyslexic users
                    color: "#333333"
                }
                Text {
                    text: levelData[currentLevel].emoji
                    font.pixelSize: 64
                }
            }
        }

        // Play Area (Tracing Board)
        Rectangle {
            width: parent.width
            height: parent.height - 120
            radius: 20
            color: "#FFFFFF"
            border.color: "#E0E0E0"
            border.width: 3
            clip: true

            Canvas {
                id: drawCanvas
                anchors.fill: parent
                anchors.margins: 40

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    ctx.lineCap = "round";
                    ctx.lineJoin = "round";

                    let raw = letterStrokes[levelData[currentLevel].letter];

                    // 1. Draw Guide Path (Light blue)
                    ctx.lineWidth = 60;
                    ctx.strokeStyle = "#D9E4F5";
                    for (let i = 0; i < raw.length; i++) {
                        let stroke = raw[i];
                        ctx.beginPath();
                        ctx.moveTo(stroke[0][0]*width, stroke[0][1]*height);
                        for(let j=1; j<stroke.length; j++) {
                            ctx.lineTo(stroke[j][0]*width, stroke[j][1]*height);
                        }
                        ctx.stroke();
                    }

                    // 2. Draw Fully Completed Strokes (Bright Orange)
                    ctx.lineWidth = 45;
                    ctx.strokeStyle = "#FF9F1C";
                    for (let i = 0; i < currentStrokeIndex; i++) {
                        let stroke = raw[i];
                        ctx.beginPath();
                        ctx.moveTo(stroke[0][0]*width, stroke[0][1]*height);
                        for(let j=1; j<stroke.length; j++) {
                            ctx.lineTo(stroke[j][0]*width, stroke[j][1]*height);
                        }
                        ctx.stroke();
                    }

                    // 3. Draw Currently Traced Portion
                    if (currentStrokeIndex < activeWaypoints.length && currentPointIndex > 0) {
                        let wps = activeWaypoints[currentStrokeIndex];
                        ctx.beginPath();
                        ctx.moveTo(wps[0][0]*width, wps[0][1]*height);
                        for (let j = 1; j <= currentPointIndex; j++) {
                            ctx.lineTo(wps[j][0]*width, wps[j][1]*height);
                        }
                        ctx.stroke();
                    }

                    // 4. Draw Guide Dot (Red Ball to guide dragging direction)
                    if (!levelFinished && currentStrokeIndex < activeWaypoints.length) {
                        let target = activeWaypoints[currentStrokeIndex][currentPointIndex];
                        ctx.fillStyle = "#FF5252";
                        ctx.beginPath();
                        ctx.arc(target[0]*width, target[1]*height, 25, 0, 2*Math.PI);
                        ctx.fill();
                    }
                }
            }

            // Accuracy Detection & Drag Logic
            MouseArea {
                anchors.fill: drawCanvas

                onPositionChanged: (mouse) => {
                    if (levelFinished || currentStrokeIndex >= activeWaypoints.length) return;

                    let target = activeWaypoints[currentStrokeIndex][currentPointIndex];
                    let tx = target[0] * drawCanvas.width;
                    let ty = target[1] * drawCanvas.height;

                    // Accuracy Threshold Detection
                    let distance = Math.hypot(mouse.x - tx, mouse.y - ty);

                    if (distance < 50) { // Grabbing distance
                        currentPointIndex++;
                        if (currentPointIndex >= activeWaypoints[currentStrokeIndex].length) {
                            // Stroke Completed!
                            currentStrokeIndex++;
                            currentPointIndex = 0;

                            if (currentStrokeIndex >= activeWaypoints.length) {
                                completeLevel();
                            } else {
                                tts.say("Good");
                            }
                        }
                        drawCanvas.requestPaint();
                    }
                }

                onReleased: {
                    // Penalty-free accuracy correction:
                    // If a kid lifts their finger early, the stroke safely resets so they learn full continuity.
                    if (!levelFinished && currentPointIndex > 0) {
                        currentPointIndex = 0;
                        drawCanvas.requestPaint();
                        tts.say("Oops, follow the red dot!");
                    }
                }
            }
        }
    }

    // --- Particle System (Congratulations Confetti) ---
    ParticleSystem {
        id: confettiSystem
        anchors.fill: parent

        ItemParticle {
            system: confettiSystem
            delegate: Rectangle {
                width: 15; height: 15
                // Assign random bright colors for confetti
                color: Qt.hsla(Math.random(), 0.8, 0.6, 1.0)
                radius: Math.random() > 0.5 ? 7.5 : 0 // Mix of circles & squares
            }
        }

        Emitter {
            id: confettiEmitter
            system: confettiSystem
            width: parent.width
            y: -20 // Start slightly above screen
            emitRate: 0
            lifeSpan: 4000
            velocity: AngleDirection { angle: 90; angleVariation: 45; magnitude: 400 }
            acceleration: AngleDirection { angle: 90; magnitude: 200 } // Gravity falling down
        }
    }
}
