import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import Dyscalculia.Numicon

Page {
    id: window
    visible: true
    width: 1024
    height: 768
    title: "Numicon Adventure"

    LogViewer { id: logViewer }

    GameEngine{
        id:gameEngine
    }

    MetricsTracker{
        id: metricsTracker
    }

    // Background
    Image {
        anchors.fill: parent
        source: "qrc:/numicon/assets/images/game_background.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    // Audio
    Audio {
        id: bgMusic
        source: "qrc:/numicon/assets/audio/background_music.mp3"
        autoPlay: true
        loops: Audio.Infinite
        volume: 0.5
    }

    Audio {
        id: correctSound
        source: "qrc:/numicon/assets/audio/correct.wav"
    }

    Audio {
        id: errorSound
        source: "qrc:/numicon/assets/audio/error.wav"
    }

    // UI Layer
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 30

        // Header: Difficulty & Question
        RowLayout {
            Layout.fillWidth: true
            
            ComboBox {
                id: difficultySelector
                model: ["Level 1: Recognize", "Level 2: Addition", "Level 3: Bonds to 10"]
                onCurrentIndexChanged: gameEngine.difficulty = currentIndex + 1
                background: Rectangle {
                    color: "white"
                    radius: 10
                    border.color: "#FF9800"
                    border.width: 2
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 80
                color: "#AAFFFFFF"
                radius: 20
                border.color: "#FF9800"
                border.width: 3

                Text {
                    anchors.centerIn: parent
                    text: gameEngine.question
                    font.pixelSize: 32
                    font.bold: true
                    color: "#333"
                }
            }
        }

        // Game Area: Numicon Options
        GridLayout {
            id: gameGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: 20
            columnSpacing: 20

            Repeater {
                model: gameEngine.options
                NumiconTile {
                    value: modelData
                    onClicked: gameEngine.submitAnswer(value)
                }
            }
        }

        // Footer: Metrics Dashboard
        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: "#CCFFFFFF"
            radius: 20
            border.color: "#4CAF50"
            border.width: 3

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 40

                Button {
                    text: "View JSON Logs"
                    onClicked: logViewer.visible = true
                    Layout.alignment: Qt.AlignVCenter
                }

                MetricItem { label: "Correct"; value: metricsTracker.totalCorrect; color: "#4CAF50" }
                MetricItem { label: "Failed"; value: metricsTracker.totalFailed; color: "#F44336" }
                MetricItem { label: "Accuracy"; value: (metricsTracker.accuracy * 100).toFixed(1) + "%"; color: "#2196F3" }
                MetricItem { label: "Speed"; value: metricsTracker.avgSpeed.toFixed(2) + "s"; color: "#FF9800" }
                MetricItem { label: "Focus"; value: (metricsTracker.concentration * 100).toFixed(0) + "%"; color: "#9C27B0" }
            }
        }
    }

    // Feedback Overlays
    Rectangle {
        id: feedbackOverlay
        anchors.fill: parent
        color: feedbackText.text === "CORRECT!" ? "#4400FF00" : "#44FF0000"
        visible: false
        opacity: 0

        Text {
            id: feedbackText
            anchors.centerIn: parent
            font.pixelSize: 120
            font.bold: true
            color: "white"
            style: Text.Outline
            styleColor: "black"
        }

        SequentialAnimation {
            id: feedbackAnim
            PropertyAction { target: feedbackOverlay; property: "visible"; value: true }
            ParallelAnimation {
                NumberAnimation { target: feedbackOverlay; property: "opacity"; from: 0; to: 1; duration: 200 }
                NumberAnimation { target: feedbackText; property: "scale"; from: 0.5; to: 1.2; duration: 300; easing.type: Easing.OutBack }
            }
            PauseAnimation { duration: 500 }
            NumberAnimation { target: feedbackOverlay; property: "opacity"; from: 1; to: 0; duration: 200 }
            PropertyAction { target: feedbackOverlay; property: "visible"; value: false }
        }
    }

    Connections {
        target: gameEngine
        onAnswerCorrect: {
            feedbackText.text = "CORRECT!"
            correctSound.play()
            feedbackAnim.start()
        }
        onAnswerIncorrect: {
            feedbackText.text = "TRY AGAIN!"
            errorSound.play()
            feedbackAnim.start()
        }
    }
}
