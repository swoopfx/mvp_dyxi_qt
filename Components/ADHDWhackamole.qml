import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

  Item {
    id: root
    visible: true
    anchors.fill: parent
    // title: "Whac-a-Mole Telemetry Game"

    property int gameDurationMs: 30000
    property int rabbitVisibleMs: 4000
    property int rabbitHiddenMs: 2000

    property int whackCount: 0
    property int hitCount: 0
    property int missCount: 0

    property real totalRabbitVisibleMs: 0
    property real totalUserAttemptMs: 0
    property real totalGameUpMs: 0
    property real totalIntervalBetweenWhacksMs: 0

    property real lastWhackTimeMs: -1
    property real rabbitShownAtMs: 0
    property real clickPressedAtMs: 0
    property real gameStartMs: 0

    property bool rabbitVisible: false
    property bool gameRunning: false

    property real attentionSpanMs: 0
    property int totalClicks: 0
    property int successfulClicks: 0
    property int prematureClicks: 0
    property real accuracyLevel: 0.0
    property real impulseControlLevel: 0.0
    property real concentrationLevel: 0.0
    property var whackIntervals: []
    property real lastSuccessfulWhackMs: -1
    property real averageWhackIntervalMs: 0
    property real intervalStdDevMs: 0

    property var reabbitEvents: ListModel{}


    function nowMs() {
        return Date.now()
    }

    function resetGame() {
        whackCount = 0
        hitCount = 0
        missCount = 0
        totalRabbitVisibleMs = 0
        totalUserAttemptMs = 0
        totalGameUpMs = 0
        totalIntervalBetweenWhacksMs = 0
        lastWhackTimeMs = -1
        rabbitShownAtMs = 0
        clickPressedAtMs = 0
        rabbitVisible = false
        gameRunning = true
        gameStartMs = nowMs()

        gameTimer.restart()
        spawnTimer.restart()
        telemetryTimer.start()
        spawnRabbit()
    }

    function endGame() {
        if (rabbitVisible)
            totalRabbitVisibleMs += nowMs() - rabbitShownAtMs

        gameRunning = false
        rabbitVisible = false
        rabbitItem.visible = false
        spawnTimer.stop()
        hideTimer.stop()
        telemetryTimer.stop()
    }

    function spawnRabbit() {
        if (!gameRunning)
            return

        rabbitVisible = true
        rabbitShownAtMs = nowMs()
        rabbitItem.visible = true
        rabbitAppear.start()

        var maxX = gameBoard.width - rabbitItem.width - 40
        var maxY = gameBoard.height - rabbitItem.height - 40
        rabbitItem.x = 20 + Math.floor(Math.random() * Math.max(1, maxX))
        rabbitItem.y = 20 + Math.floor(Math.random() * Math.max(1, maxY))

        hideTimer.interval = rabbitVisibleMs
        hideTimer.restart()
    }

    function hideRabbit() {
        if (!gameRunning || !rabbitVisible)
            return

        totalRabbitVisibleMs += nowMs() - rabbitShownAtMs
        rabbitVisible = false
        rabbitDisappear.start()
    }

    function recordAttempt(isHit) {
        var endMs = nowMs()
        totalUserAttemptMs += Math.max(0, endMs - clickPressedAtMs)

        if (isHit) {
            whackCount += 1
            hitCount += 1
            if (lastWhackTimeMs > 0)
                totalIntervalBetweenWhacksMs += endMs - lastWhackTimeMs
            lastWhackTimeMs = endMs
        } else {
            missCount += 1
        }
    }

    function updateDerivedMetrics() {
        totalClicks = successfulClicks + prematureClicks
        accuracyLevel = totalClicks > 0 ? successfulClicks / totalClicks : 0.0
        impulseControlLevel = totalClicks > 0 ? 1.0 - (prematureClicks / totalClicks) : 0.0

        if (whackIntervals.length > 0) {
            var sum = 0
            for (var i = 0; i < whackIntervals.length; i++)
                sum += whackIntervals[i]
            averageWhackIntervalMs = sum / whackIntervals.length

            var varianceSum = 0
            for (var j = 0; j < whackIntervals.length; j++) {
                var diff = whackIntervals[j] - averageWhackIntervalMs
                varianceSum += diff * diff
            }
            intervalStdDevMs = Math.sqrt(varianceSum / whackIntervals.length)
        } else {
            averageWhackIntervalMs = 0
            intervalStdDevMs = 0
        }

        var consistencyScore = 1.0
        if (averageWhackIntervalMs > 0)
            consistencyScore = Math.max(0, 1.0 - (intervalStdDevMs / averageWhackIntervalMs))

        concentrationLevel = (accuracyLevel * 0.5) + (impulseControlLevel * 0.3) + (consistencyScore * 0.2)
    }

    Timer {
        id: gameTimer
        interval: root.gameDurationMs
        repeat: false
        onTriggered: {
            root.totalGameUpMs = root.nowMs() - root.gameStartMs
            root.endGame()
        }
    }

    Timer {
        id: spawnTimer
        interval: root.rabbitHiddenMs
        repeat: true
        onTriggered: {
            if (root.gameRunning && !root.rabbitVisible)
                root.spawnRabbit()
        }
    }

    Timer {
        id: hideTimer
        interval: root.rabbitVisibleMs
        repeat: false
        onTriggered: root.hideRabbit()
    }

    Timer {
        id: telemetryTimer
        interval: 100
        repeat: true
        running: false
        onTriggered: {
            if (root.gameRunning)
                root.totalGameUpMs = root.nowMs() - root.gameStartMs
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#a9d6ff"

        Image {
            anchors.fill: parent
            source: "qrc:/img/images/background.png"
            fillMode: Image.PreserveAspectCrop
            opacity: 0.95
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Button {
                    text: root.gameRunning ? "Restart" : "Start Game"
                    onClicked: root.resetGame()
                }

                Label {
                    text: root.gameRunning ? "Game running..." : "Ready"
                    color: "white"
                    font.bold: true
                }
            }

            Rectangle {
                id: gameBoard
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 18
                color: "transparent"
                border.color: "#ffffff"
                border.width: 2
                clip: true

                Image {
                    anchors.fill: parent
                    source: "qrc:/img/images/grass.png"
                    fillMode: Image.PreserveAspectCrop
                }

                Repeater {
                    model: 5
                    delegate: Image {
                        source: "qrc:/img/images/cloud.png"
                        width: 120
                        height: 70
                        opacity: 0.35
                        x: (index * 180) % (gameBoard.width - 140)
                        y: 20 + (index % 2) * 50

                        SequentialAnimation on x {
                            running: root.gameRunning
                            loops: Animation.Infinite
                            NumberAnimation { from: x; to: x + 60; duration: 2500 }
                            NumberAnimation { from: x + 60; to: x; duration: 2500 }
                        }
                    }
                }

                Image {
                    id: holeItem
                    source:  "qrc:/img/images/hole.png"
                    width: 170
                    height: 110
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 65
                    smooth: true
                }

                Image {
                    id: rabbitItem
                    source:  "qrc:/img/images/rabbit.png"
                    width: 400
                    height: 400
                    visible: false
                    smooth: true
                    scale: 0.8
                    opacity: 0.0

                    NumberAnimation on opacity {
                        id: rabbitAppear
                        from: 0.0
                        to: 1.0
                        duration: 120
                    }

                    NumberAnimation on opacity {
                        id: rabbitDisappear
                        from: 1.0
                        to: 0.0
                        duration: 120
                    }

                    ScaleAnimator {
                        target: rabbitItem
                        from: 0.2
                        to: 1.0
                        duration: 120
                        running: false
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: root.clickPressedAtMs = root.nowMs()
                        onClicked: {
                            if (!root.gameRunning)
                                return

                            root.totalClicks += 1

                            if (root.rabbitVisible) {

                                root.successfulClicks += 1

                                if(root.lastSuccessfulWhackMs > 0)
                                    root.whackIntervals.push(root.nowMs() - root.lastSuccessfulWhackMs)

                               root.lastSuccessfulWhackMs = root.nowMs()
                                root.hideRabbit()
                                root.recordAttempt(true)
                                root.spawnTimer.restart()
                                root.spawnRabbit()
                            } else {
                                root.prematureClicks += 1
                                root.recordAttempt(false)
                            }

                            root.updateDerivedMetrics()
                        }
                    }
                }
            }

            GroupBox {
                title: "Telemetry"
                Layout.fillWidth: true

                GridLayout {
                    columns: 2
                    columnSpacing: 20
                    rowSpacing: 6
                    anchors.fill: parent

                    Label { text: "Total whacks:" }
                    Label { text: root.whackCount }

                    Label { text: "Hits:" }
                    Label { text: root.hitCount }

                    Label { text: "Misses:" }
                    Label { text: root.missCount }

                    Label { text: "Rabbit visible time:" }
                    Label { text: Math.round(root.totalRabbitVisibleMs) + " ms" }

                    Label { text: "User attempt time:" }
                    Label { text: Math.round(root.totalUserAttemptMs) + " ms" }

                    Label { text: "Total game up time:" }
                    Label { text: Math.round(root.totalGameUpMs) + " ms" }

                    Label { text: "Interval between whacks:" }
                    Label { text: Math.round(root.totalIntervalBetweenWhacksMs) + " ms" }
                }
            }
        }
    }
}