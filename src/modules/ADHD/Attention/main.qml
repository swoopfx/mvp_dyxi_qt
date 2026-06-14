import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Shapes
import AdhdWhackProject 1.0

ApplicationWindow {
    id: window
    width: 1024
    height: 768
    visible: true
    title: qsTr("ADHD Cognitive Tracker & Attention Assessment (Qt 6)")

    color: "#030712" // Slate-950 dark background

    // Global application states
    property int playerAge: 8
    property int currentDifficulty: 1 // 0: Easy (2x2), 1: Standard (3x3), 2: High Density (4x4)
    property string activeScreen: "welcome" // welcome, playing, results

    // Game variables
    property int score: 0
    property int combo: 0
    property real timeRemaining: 30.0
    property int spawnsLeft: 25
    property var activeMoles: [] // Collection of active mole models
    property var eventLogs: [] // JSON structure of raw millisecond event stream
    property var calculatedMetrics: null

    // Session settings per difficulty
    property var difficultyConfigs: [
        { "name": "Preschool Easy", "gridSize": 2, "spawnInterval": 1400, "moleDuration": 2200 },
        { "name": "Pediatric Standard", "gridSize": 3, "spawnInterval": 1000, "moleDuration": 1500 },
        { "name": "Adolescent ADHD Stress Test", "gridSize": 4, "spawnInterval": 800, "moleDuration": 1100 }
    ]

    function getActiveConfig() {
        return difficultyConfigs[currentDifficulty];
    }

    // High fidelity synthetic sounds using built-in platforms or standard mock triggers
    function playBeep(frequency, duration) {
        // High fidelity tone synthesizers can be plugged here
        console.log("Audio frequency synthesiser trigger: " + frequency + " Hz for " + duration + "ms");
    }

    // Interactive helper models for QML grid view
    ListModel {
        id: gridCells
    }

    function setupGrid() {
        gridCells.clear();
        var size = getActiveConfig().gridSize;
        for (var i = 0; i < size * size; i++) {
            gridCells.append({ "cellIndex": i, "isMoleActive": false, "moleType": "", "spawnTime": 0 });
        }
    }

    // Cognitive game engine timer
    Timer {
        id: gameTimer
        interval: 100
        running: activeScreen === "playing"
        repeat: true
        onTriggered: {
            timeRemaining -= 0.1;
            if (timeRemaining <= 0) {
                timeRemaining = 0;
                stopGame();
            }
        }
    }

    // Spawn timer
    Timer {
        id: spawnTimer
        interval: getActiveConfig().spawnInterval
        running: activeScreen === "playing"
        repeat: true
        onTriggered: {
            spawnNextMole();
        }
    }

    function startGame() {
        score = 0;
        combo = 0;
        timeRemaining = 30.0;
        eventLogs = [];
        calculatedMetrics = null;
        setupGrid();
        activeScreen = "playing";
        logTimelineEvent("START_GAME", "SYSTEM", 0);
        spawnNextMole();
    }

    function stopGame() {
        activeScreen = "results";
        logTimelineEvent("END_GAME", "SYSTEM", 1);
        calculatedMetrics = cognitiveEngine.calculateMetrics(eventLogs, playerAge, currentDifficulty);
    }

    function logTimelineEvent(type, moleType, durationSinceSpawn) {
        var now = Date.now();
        var ev = {
            "type": type,
            "moleType": moleType,
            "timestamp": now,
            "durationSinceSpawn": durationSinceSpawn
        };
        eventLogs.push(ev);
    }

    function spawnNextMole() {
        var config = getActiveConfig();
        var totalCells = config.gridSize * config.gridSize;
        var availableCells = [];

        for (var i = 0; i < totalCells; i++) {
            if (!gridCells.get(i).isMoleActive) {
                availableCells.push(i);
            }
        }

        if (availableCells.length === 0) return;

        var randomIndex = availableCells[Math.floor(Math.random() * availableCells.length)];

        // Decide type based on clinical distributions
        var rand = Math.random();
        var type = "REGULAR_MOLE";
        if (rand < 0.15) {
            type = "GOLDEN_MOLE";
        } else if (rand < 0.30) {
            type = "DISTRACTOR_CUTE"; // Target block (should sleep, do not click)
        } else if (rand < 0.40) {
            type = "DISTRACTOR_BOMB"; // Warning hazard block (severe motor error index)
        }

        var cell = gridCells.get(randomIndex);
        cell.isMoleActive = true;
        cell.moleType = type;
        cell.spawnTime = Date.now();

        logTimelineEvent("SPAWN", type, 0);

        // Auto despawn timer for this mole
        var despawnTimer = Qt.createQmlObject("import QtQuick 2.0; Timer { interval: " + config.moleDuration + "; running: true; repeat: false; }", window);
        despawnTimer.triggered.connect(function() {
            var currentCell = gridCells.get(randomIndex);
            if (currentCell && currentCell.isMoleActive && currentCell.spawnTime === cell.spawnTime) {
                currentCell.isMoleActive = false;
                logTimelineEvent("DESPAWN", type, config.moleDuration);

                // Show red "X" for missed active targets (omission error)
                if (type === "REGULAR_MOLE" || type === "GOLDEN_MOLE") {
                    var cellItem = gameGrid.children[randomIndex];
                    if (cellItem) {
                        cellItem.triggerFeedback("MISS");
                    }
                }
            }
            despawnTimer.destroy();
        });
    }

    function whackMole(index) {
        var cell = gridCells.get(index);
        var cellItem = gameGrid.children[index];
        if (!cell.isMoleActive) {
            // Hyperactivity empty panel click
            score -= 50;
            combo = 0;
            playBeep(300, 100);
            if (cellItem) {
                cellItem.triggerFeedback("MISS");
                floatingTextOverlay.triggerFloatingText(index, "Restless! -50", "#f43f5e");
            }
            logTimelineEvent("BLANK_CLICK", "EMPTY", 0);
            return;
        }

        var rt = Date.now() - cell.spawnTime;
        cell.isMoleActive = false;

        logTimelineEvent("HIT", cell.moleType, rt);

        if (cell.moleType === "REGULAR_MOLE") {
            score += 100;
            combo += 1;
            playBeep(980, 80); // Diagnostic calibration high beep
            floatingTextOverlay.triggerFloatingText(index, "+100", "#10b981");
            if (cellItem) cellItem.triggerFeedback("HIT");
        } else if (cell.moleType === "GOLDEN_MOLE") {
            score += 300;
            combo += 2;
            playBeep(1420, 120); // Extra gold pitch
            floatingTextOverlay.triggerFloatingText(index, "GOLD! +300", "#fbbf24");
            if (cellItem) cellItem.triggerFeedback("HIT");
        } else if (cell.moleType === "DISTRACTOR_CUTE") {
            score -= 150;
            combo = 0;
            playBeep(440, 150); // Low dull tone
            floatingTextOverlay.triggerFloatingText(index, "Distracted! -150", "#a855f7");
            if (cellItem) cellItem.triggerFeedback("MISS");
        } else if (cell.moleType === "DISTRACTOR_BOMB") {
            score -= 300;
            combo = 0;
            playBeep(220, 300); // Low failure buzzer
            floatingTextOverlay.triggerFloatingText(index, "DANGER BOMB! -300", "#ef4444");
            if (cellItem) cellItem.triggerFeedback("MISS");
        }
    }

    // HEADER SECTION
    Rectangle {
        id: headerBar
        width: parent.width
        height: 70
        color: "#0c1f1a"
        border.color: "#065f46"
        border.width: 1

        Row {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 20

            Text {
                text: "🧠 ADHD COGNITIVE CLINICAL ENGINE v1.0"
                color: "#10b981"
                font.pixelSize: 18
                font.bold: true
                font.family: "monospace"
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 2
                height: 30
                color: "#065f46"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "ACTIVE AGE: " + playerAge + " YEARS"
                color: "#9ca3af"
                font.pixelSize: 14
                font.bold: true
                font.family: "monospace"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // MAIN CONTENT CONTAINER
    Item {
        id: mainContainer
        anchors.top: headerBar.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        // SCREEN 1: WELCOME SCREEN
        Rectangle {
            id: welcomeScreen
            anchors.fill: parent
            color: "#030712"
            visible: activeScreen === "welcome"

            Column {
                anchors.centerIn: parent
                spacing: 30
                width: 500

                Text {
                    text: "ADHD Attention Tracker"
                    color: "#ffffff"
                    font.pixelSize: 32
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "sans-serif"
                }

                Text {
                    text: "A Qt6 Native Cognitive Assessment System analyzing response inhibition, distractibility and motor impulsivity metrics."
                    color: "#9ca3af"
                    font.pixelSize: 15
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "sans-serif"
                }

                // Age selector
                Column {
                    spacing: 10
                    width: parent.width

                    Text {
                        text: "Enter Patient Chronological Age (4 - 18):"
                        color: "#10b981"
                        font.pixelSize: 14
                        font.bold: true
                        font.family: "monospace"
                    }

                    Row {
                        spacing: 15
                        width: parent.width

                        Button {
                            text: "-"
                            onClicked: if (playerAge > 4) playerAge--
                            width: 50
                            height: 40
                        }

                        Rectangle {
                            width: 150
                            height: 40
                            color: "#0f172a"
                            border.color: "#334155"
                            radius: 8

                            Text {
                                anchors.centerIn: parent
                                text: playerAge + " Years"
                                color: "#ffffff"
                                font.pixelSize: 16
                                font.bold: true
                            }
                        }

                        Button {
                            text: "+"
                            onClicked: if (playerAge < 18) playerAge++
                            width: 50
                            height: 40
                        }
                    }
                }

                // Difficulty selectors
                Column {
                    spacing: 10
                    width: parent.width

                    Text {
                        text: "Select Diagnostic Assessment Mode:"
                        color: "#10b981"
                        font.pixelSize: 14
                        font.bold: true
                        font.family: "monospace"
                    }

                    Row {
                        spacing: 10
                        width: parent.width

                        Repeater {
                            model: [ "Preschool", "Pediatric", "Adolescent" ]
                            delegate: Button {
                                text: modelData
                                highlighted: currentDifficulty === index
                                width: (parent.width - 20) / 3
                                onClicked: currentDifficulty = index
                            }
                        }
                    }
                }

                Button {
                    text: "LAUNCH COGNITIVE TEST"
                    font.bold: true
                    width: parent.width
                    height: 55
                    onClicked: {
                        startGame();
                    }
                }
            }
        }

        // SCREEN 2: GAME SCREEN
        Rectangle {
            id: gameScreen
            anchors.fill: parent
            color: "#030712"
            visible: activeScreen === "playing"

            // Game grid
            Grid {
                id: gameGrid
                anchors.centerIn: parent
                columns: getActiveConfig().gridSize
                spacing: 15

                Repeater {
                    model: gridCells
                    delegate: Rectangle {
                        id: cellContainer
                        width: getActiveConfig().gridSize === 2 ? 200 : getActiveConfig().gridSize === 3 ? 140 : 100
                        height: width
                        color: "#064e3b"
                        radius: 12
                        border.color: "#059669"
                        border.width: 1

                        property string feedbackType: ""

                        Timer {
                            id: feedbackTimer
                            interval: 800
                            repeat: false
                            onTriggered: {
                                cellContainer.feedbackType = "";
                            }
                        }

                        function triggerFeedback(type) {
                            feedbackType = type;
                            feedbackTimer.restart();
                        }

                        // Inner dark recessed tube pit
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 10
                            color: "#022c22"
                            radius: 8
                        }

                        // Mole representation using Vector graphics custom painter Canvas
                        Canvas {
                            anchors.fill: parent
                            visible: isMoleActive
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();

                                // Draw different styles of experimental targets
                                if (moleType === "REGULAR_MOLE") {
                                    ctx.fillStyle = "#8b5cf6"; // Purple troll
                                    ctx.beginPath();
                                    ctx.ellipse(width/2 - 25, height/2 - 20, 50, 60);
                                    ctx.fill();
                                    // Eyes
                                    ctx.fillStyle = "#ffffff";
                                    ctx.beginPath();
                                    ctx.arc(width/2 - 12, height/2 - 15, 6, 0, 2*Math.PI);
                                    ctx.arc(width/2 + 12, height/2 - 15, 6, 0, 2*Math.PI);
                                    ctx.fill();
                                    // Angry eyebrows
                                    ctx.strokeStyle = "#ffffff";
                                    ctx.lineWidth = 2;
                                    ctx.beginPath();
                                    ctx.moveTo(width/2 - 20, height/2 - 25);
                                    ctx.lineTo(width/2 - 5, height/2 - 20);
                                    ctx.moveTo(width/2 + 20, height/2 - 25);
                                    ctx.lineTo(width/2 + 5, height/2 - 20);
                                    ctx.stroke();
                                } else if (moleType === "GOLDEN_MOLE") {
                                    ctx.fillStyle = "#fbbf24"; // Shiny Golden rabbit
                                    ctx.beginPath();
                                    ctx.ellipse(width/2 - 25, height/2 - 15, 50, 50);
                                    ctx.fill();
                                    // Ears
                                    ctx.fillStyle = "#fbbf24";
                                    ctx.ellipse(width/2 - 18, height/2 - 45, 12, 40);
                                    ctx.ellipse(width/2 + 18, height/2 - 45, 12, 40);
                                    ctx.fill();
                                } else if (moleType === "DISTRACTOR_CUTE") {
                                    ctx.fillStyle = "#22c55e"; // Friendly sleeping frog
                                    ctx.beginPath();
                                    ctx.ellipse(width/2 - 25, height/2 - 15, 50, 45);
                                    ctx.fill();
                                    // Cheeks
                                    ctx.fillStyle = "#ec4899";
                                    ctx.ellipse(width/2 - 18, height/2, 8, 5);
                                    ctx.ellipse(width/2 + 18, height/2, 8, 5);
                                    ctx.fill();
                                } else if (moleType === "DISTRACTOR_BOMB") {
                                    ctx.fillStyle = "#ef4444"; // Spike danger ball
                                    ctx.beginPath();
                                    ctx.arc(width/2, height/2, 28, 0, 2*Math.PI);
                                    ctx.fill();
                                    // Warning sign
                                    ctx.fillStyle = "#ffffff";
                                    ctx.font = "bold 18px sans-serif";
                                    ctx.fillText("!", width/2 - 5, height/2 + 6);
                                }
                            }

                            // Trigger paint refresh on visibility toggle
                            onVisibleChanged: {
                                if (visible) requestPaint();
                            }
                        }

                        // Label indicators
                        Text {
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: isMoleActive ? (moleType === "DISTRACTOR_CUTE" ? "REST" : moleType === "DISTRACTOR_BOMB" ? "HAZARD" : (moleType === "GOLDEN_MOLE" ? "GOLD" : "WHACK")) : ""
                            color: moleType === "DISTRACTOR_BOMB" ? "#ef4444" : (moleType === "DISTRACTOR_CUTE" ? "#a855f7" : "#34d399")
                            font.pixelSize: 10
                            font.bold: true
                            font.family: "monospace"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                whackMole(cellIndex);
                            }
                        }

                        // Animated Hit or Miss Graphical Presentation (Big Green Checkmark vs Big Red X)
                        Rectangle {
                            id: feedbackOverlay
                            anchors.fill: parent
                            anchors.margins: 8
                            color: "transparent"
                            visible: cellContainer.feedbackType !== ""
                            z: 100

                            scale: cellContainer.feedbackType !== "" ? 1.05 : 0.35
                            opacity: cellContainer.feedbackType !== "" ? 1.0 : 0.0

                            Behavior on scale {
                                NumberAnimation { duration: 150; easing.type: Easing.OutBack }
                            }
                            Behavior on opacity {
                                NumberAnimation { duration: 250 }
                            }

                            Rectangle {
                                anchors.centerIn: parent
                                width: Math.min(parent.width, parent.height) * 0.75
                                height: width
                                radius: width / 2
                                color: cellContainer.feedbackType === "HIT" ? "#10b981" : "#ef4444"
                                border.color: "#ffffff"
                                border.width: 3

                                Text {
                                    anchors.centerIn: parent
                                    text: cellContainer.feedbackType === "HIT" ? "✓" : "✗"
                                    color: "#ffffff"
                                    font.pixelSize: parent.width * 0.45
                                    font.bold: true
                                    font.family: "sans-serif"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    // Set explicit baseline centering for text icons
                                    anchors.horizontalCenterOffset: 0
                                    anchors.verticalCenterOffset: -1
                                }
                            }
                        }
                    }
                }
            }

            // Top score / indicators overlay
            Rectangle {
                width: parent.width - 60
                height: 50
                color: "#1e293b"
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 10

                Row {
                    anchors.centerIn: parent
                    spacing: 40

                    Text {
                        text: "SCORE: " + score
                        color: "#fbbf24"
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "monospace"
                    }

                    Text {
                        text: "TIME LEFT: " + timeRemaining.toFixed(1) + "S"
                        color: "#ef4444"
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "monospace"
                    }

                    Text {
                        text: "COMBO: " + combo + "x"
                        color: "#60a5fa"
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "monospace"
                    }
                }
            }

            // Interactive flying score text overlay
            Item {
                id: floatingTextOverlay
                anchors.fill: parent
                z: 100

                function triggerFloatingText(cellIdx, message, col) {
                    var point = gameGrid.children[cellIdx];
                    if (!point) return;

                    var obj = floatingTextComponent.createObject(floatingTextOverlay, {
                        x: gameGrid.x + point.x + point.width / 2,
                        y: gameGrid.y + point.y + point.height / 2,
                        text: message,
                        textColor: col
                    });
                }

                Component {
                    id: floatingTextComponent
                    Text {
                        id: animText
                        property color textColor: "white"
                        color: textColor
                        font.pixelSize: 16
                        font.bold: true
                        font.family: "monospace"

                        NumberAnimation on y {
                            from: animText.y
                            to: animText.y - 60
                            duration: 800
                            easing.type: Easing.OutQuad
                        }

                        NumberAnimation on opacity {
                            from: 1.0
                            to: 0.0
                            duration: 800
                        }

                        Timer {
                            interval: 850
                            running: true
                            onTriggered: animText.destroy()
                        }
                    }
                }
            }
        }

        // SCREEN 3: CLINICAL DIAGNOSTIC REPORT CARD
        Rectangle {
            id: resultsScreen
            anchors.fill: parent
            color: "#030712"
            visible: activeScreen === "results"

            ScrollView {
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: 900
                clip: true

                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 700
                    spacing: 25
                    topPadding: 30
                    bottomPadding: 50

                    Text {
                        text: "📊 ADHD ATTENTION PROFILING REPORT"
                        color: "#10b981"
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "monospace"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#1e293b"
                    }

                    // Main statistical bento grids
                    Grid {
                        width: parent.width
                        columns: 2
                        spacing: 20

                        // Card 1: Attentional Indicators
                        Rectangle {
                            width: (parent.width - 20) / 2
                            height: 160
                            color: "#0c1f1a"
                            border.color: "#065f46"
                            radius: 12

                            Column {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 10

                                Text {
                                    text: "SUSTAINED ATTENTION INDEX"
                                    color: "#9ca3af"
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: "monospace"
                                }

                                Text {
                                    text: calculatedMetrics ? (calculatedMetrics.sustainedAttention).toFixed(1) + "%" : "0.0%"
                                    color: "#10b981"
                                    font.pixelSize: 32
                                    font.bold: true
                                }

                                Text {
                                    text: "Quantified focus stability over entire whacking session runtime matrix."
                                    color: "#6b7280"
                                    font.pixelSize: 11
                                    width: parent.width - 20
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }

                        // Card 2: Motor Control / Impulsivity
                        Rectangle {
                            width: (parent.width - 20) / 2
                            height: 160
                            color: "#1c1917"
                            border.color: "#7c2d12"
                            radius: 12

                            Column {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 10

                                Text {
                                    text: "IMPULSIVITY (HAZARD HIT RATIO)"
                                    color: "#fca5a5"
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: "monospace"
                                }

                                Text {
                                    text: calculatedMetrics ? (calculatedMetrics.impulsivityIndex).toFixed(1) + "%" : "0.0%"
                                    color: "#ef4444"
                                    font.pixelSize: 32
                                    font.bold: true
                                }

                                Text {
                                    text: "Rate of clicks triggered on explicit danger/bomb hazards. High rate signifies motor inhibition delay."
                                    color: "#78716c"
                                    font.pixelSize: 11
                                    width: parent.width - 20
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }

                        // Card 3: Reaction Time Speed Index
                        Rectangle {
                            width: (parent.width - 20) / 2
                            height: 160
                            color: "#0f172a"
                            border.color: "#1e3a8a"
                            radius: 12

                            Column {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 10

                                Text {
                                    text: "MEAN REACTION TIME (RT)"
                                    color: "#93c5fd"
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: "monospace"
                                }

                                Text {
                                    text: calculatedMetrics ? (calculatedMetrics.speedIndex).toFixed(0) + " ms" : "0 ms"
                                    color: "#3b82f6"
                                    font.pixelSize: 32
                                    font.bold: true
                                }

                                Text {
                                    text: "Average latency from target object spawn index to success click."
                                    color: "#64748b"
                                    font.pixelSize: 11
                                    width: parent.width - 20
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }

                        // Card 4: Distractibility Index
                        Rectangle {
                            width: (parent.width - 20) / 2
                            height: 160
                            color: "#3b0764"
                            border.color: "#6b21a8"
                            radius: 12

                            Column {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 10

                                Text {
                                    text: "DISTRACTIBILITY INDEX"
                                    color: "#d8b4fe"
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: "monospace"
                                }

                                Text {
                                    text: calculatedMetrics ? (calculatedMetrics.distractibilityIndex).toFixed(1) + "%" : "0.0%"
                                    color: "#a855f7"
                                    font.pixelSize: 32
                                    font.bold: true
                                }

                                Text {
                                    text: "Rate of un-inhibited clicks directed towards resting cute distractors."
                                    color: "#a21caf"
                                    font.pixelSize: 11
                                    width: parent.width - 20
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }

                        // Card 5: Cognitive Score
                        Rectangle {
                            width: (parent.width - 20) / 2
                            height: 160
                            color: "#022c22"
                            border.color: "#0d9488"
                            radius: 12

                            Column {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 10

                                Text {
                                    text: "OVERALL COGNITIVE SCORE"
                                    color: "#2dd4bf"
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: "monospace"
                                }

                                Text {
                                    text: calculatedMetrics ? (calculatedMetrics.cognitiveScore).toFixed(1) + "%" : "0.0%"
                                    color: "#14b8a6"
                                    font.pixelSize: 32
                                    font.bold: true
                                }

                                Text {
                                    text: "Composite executive functioning output based on response inhibition, reaction speed, and tracking consistency."
                                    color: "#0f766e"
                                    font.pixelSize: 11
                                    width: parent.width - 20
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }

                        // Card 6: Stability Index
                        Rectangle {
                            width: (parent.width - 20) / 2
                            height: 160
                            color: "#1e1b4b"
                            border.color: "#4338ca"
                            radius: 12

                            Column {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 10

                                Text {
                                    text: "STABILITY INDEX"
                                    color: "#a5b4fc"
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: "monospace"
                                }

                                Text {
                                    text: calculatedMetrics ? (calculatedMetrics.stabilityIndex).toFixed(1) + "%" : "0.0%"
                                    color: "#6366f1"
                                    font.pixelSize: 32
                                    font.bold: true
                                }

                                Text {
                                    text: "Vigilance and reaction speed stability rating. High rating reflects uniform executive focus and motor control rhythm."
                                    color: "#4f46e5"
                                    font.pixelSize: 11
                                    width: parent.width - 20
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }

                    // Combined probability diagnostic card
                    Rectangle {
                        width: parent.width
                        height: 130
                        color: "#020617"
                        border.color: "#1e293b"
                        radius: 12

                        Row {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 30

                            Column {
                                width: parent.width * 0.65
                                spacing: 10

                                Text {
                                    text: "CLINICAL PROFILE SUMMARY:"
                                    color: "#ffffff"
                                    font.pixelSize: 14
                                    font.bold: true
                                }

                                Text {
                                    text: calculatedMetrics && calculatedMetrics.adhdProbability > 40
                                        ? "Assessment reveals signs of elevated response variability and distractibility. Suggestive of potential attention variance. Recommend subsequent standard CPT comparison evaluation."
                                        : "Attentional profile falls cleanly within typical pediatric control bounds. Strong speed indices, highly competent executive control performance, good reaction tone coherence."
                                    color: "#9ca3af"
                                    font.pixelSize: 12
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }
                            }

                            Rectangle {
                                width: 2
                                height: parent.height - 10
                                color: "#1e293b"
                            }

                            Column {
                                width: parent.width * 0.25
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 5

                                Text {
                                    text: "COGNITIVE STRESS RA"
                                    color: "#6b7280"
                                    font.pixelSize: 9
                                    font.bold: true
                                    font.family: "monospace"
                                }

                                Text {
                                    text: calculatedMetrics ? (calculatedMetrics.adhdProbability).toFixed(0) + "%" : "0%"
                                    color: calculatedMetrics && calculatedMetrics.adhdProbability > 45 ? "#f97316" : "#10b981"
                                    font.pixelSize: 28
                                    font.bold: true
                                }
                            }
                        }
                    }

                    // Row of primary operations
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 20

                        Button {
                            text: "RUN NEW TEST METHOD"
                            font.bold: true
                            onClicked: {
                                activeScreen = "welcome";
                            }
                        }

                        Button {
                            text: "EXPORT LOCAL SESSION LOGS"
                            onClicked: {
                                var payload = {
                                    "age": playerAge,
                                    "difficulty": currentDifficulty,
                                    "score": score,
                                    "timestamp": Date.now(),
                                    "results": calculatedMetrics
                                };
                                var rawJson = cognitiveEngine.exportSessionToJson(payload);
                                console.log("SESSION SYSTEM JSON TRACE:
" + rawJson);
                            }
                        }
                    }
                }
            }
        }
    }
}
