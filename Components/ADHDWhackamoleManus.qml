import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "../js/TelemetryManager.js" as Telemetry

Page {
    id: gameWindow
   anchors.fill: parent
    visible: true
    // title: "Whac-A-Mole Telemetry Edition"

    property int score: 0
    property int timeLeft: 30
    property bool gameRunning: false

    function recordWhackAttempt(isHit, clickDuration) {
        Telemetry.recordWhack(isHit, clickDuration);
    }

    Image {
        id: background
        anchors.fill: parent
        source:"qrc:/img/images/background.png"
        fillMode: Image.PreserveAspectCrop
    }

    Grid {
        id: moleGrid
        anchors.centerIn: parent
        columns: 3
        spacing: 40

        Repeater {
            model: 9
            Mole {
                id: mole
                onHit: (shownAt, pressDownAt, pressDuration) => {
                    score++;
                    Telemetry.recordAppearance(shownAt, pressDownAt, 1500, pressDuration, true);
                }
            }
        }
    }

    Timer {
        id: gameTimer
        interval: 1000
        repeat: true
        onTriggered: {
            timeLeft--;
            if (timeLeft <= 0) {
                stopGame();
            }
        }
    }

    Timer {
        id: spawnTimer
        interval: 1000
        repeat: true
        onTriggered: {
            var index = Math.floor(Math.random() * 9);
            var mole = moleGrid.children[index];
            if (!mole.active) {
                mole.popUp();
                var shownTime = mole.shownAtMs;
                // If not hit within 1.5s, hide it and record as missed
                Qt.createQmlObject('import QtQuick 2.15; Timer { interval: 1500; running: true; onTriggered: { if(mole.active) { mole.hide(); Telemetry.recordAppearance(' + shownTime + ', 0, 1500, 0, false); } destroy(); } }', mole);
            }
        }
    }

    Rectangle {
        id: uiOverlay
        anchors.top: parent.top
        width: parent.width
        height: 60
        color: "#80000000"

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            text: "Score: " + score
            color: "white"
            font.pixelSize: 24
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            text: "Time: " + timeLeft
            color: "white"
            font.pixelSize: 24
        }
    }

    Button {
        id: startButton
        anchors.centerIn: parent
        text: "Start Game"
        visible: !gameRunning
        onClicked: startGame()
    }

    Rectangle {
        id: resultOverlay
        anchors.fill: parent
        color: "#CC000000"
        visible: false

        Column {
            anchors.centerIn: parent
            spacing: 20
            Text {
                text: "Game Over!"
                color: "white"
                font.pixelSize: 48
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "Final Score: " + score
                color: "white"
                font.pixelSize: 32
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Button {
                text: "Show Telemetry JSON"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var data = Telemetry.getFinalTelemetry();
                    telemetryText.text = JSON.stringify(data, null, 2);
                    telemetryScroll.visible = true;
                }
            }
            Button {
                text: "Restart"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: startGame()
            }
        }
    }

    ScrollView {
        id: telemetryScroll
        anchors.fill: parent
        anchors.margins: 50
        visible: false
        background: Rectangle { color: "white" }

        TextArea {
            id: telemetryText
            readOnly: true
            font.family: "Monospace"
            font.pixelSize: 12
        }

        Button {
            text: "Close"
            anchors.right: parent.right
            anchors.top: parent.top
            onClicked: telemetryScroll.visible = false
        }
    }

    function startGame() {
        score = 0;
        timeLeft = 30;
        gameRunning = true;
        resultOverlay.visible = false;
        telemetryScroll.visible = false;
        Telemetry.startGame();
        gameTimer.start();
        spawnTimer.start();
    }

    function stopGame() {
        gameRunning = false;
        gameTimer.stop();
        spawnTimer.stop();
        resultOverlay.visible = true;
    }
}
