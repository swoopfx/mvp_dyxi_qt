import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import MathDice 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 600
    title: "Math Dice Adventure"

    background: Image {
        source: "../assets/images/background_main.png"
        fillMode: Image.PreserveAspectCrop
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Header
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Target: " + gameEngine.target
                font.pixelSize: 48
                color: "#FFFFFF"
                font.bold: true
                style: Text.Outline
                styleColor: "#000000"
            }
            Item { Layout.fillWidth: true }
            ComboBox {
                model: ["Easy", "Medium", "Hard"]
                onCurrentTextChanged: gameEngine.difficulty = currentText
            }
        }

        // Dice Area
        Row {
            Layout.alignment: Qt.AlignCenter
            spacing: 20
            Repeater {
                model: gameEngine.scoringDice
                AnimatedDice {
                    value: modelData
                    diceColor: index === 0 ? "#FFEBEE" : "#E3F2FD"
                }
            }
        }

        // Equation Input
        TextField {
            id: equationInput
            Layout.fillWidth: true
            placeholderText: "Enter your equation (e.g. 3 + 4)"
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
        }

        // Controls
        RowLayout {
            Layout.alignment: Qt.AlignCenter
            spacing: 20
            Button {
                text: "Submit"
                highlighted: true
                onClicked: {
                    if (gameEngine.validateEquation(equationInput.text)) {
                        equationInput.text = ""
                        gameEngine.rollDice()
                    }
                }
            }
            Button {
                text: "Roll Again"
                onClicked: gameEngine.rollDice()
            }
            Button {
                text: "Start Focus Sprint"
                visible: !gameEngine.isFocusSprintActive()
                onClicked: gameEngine.startFocusSprint()
            }
        }

        // Focus Sprint Progress
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#40000000"
            radius: 20
            visible: gameEngine.isFocusSprintActive()
            RowLayout {
                anchors.centerIn: parent
                Text { color: "white"; text: "Focus Sprint Progress: " + gameEngine.focusSprintProgress() + "/5" }
                ProgressBar {
                    from: 0; to: 5
                    value: gameEngine.focusSprintProgress()
                    Layout.preferredWidth: 200
                }
            }
        }

        // Metrics Toggle
        Button {
            text: "View Detailed Stats"
            Layout.alignment: Qt.AlignCenter
            onClicked: metricsPopup.open()
        }

        Popup {
            id: metricsPopup
            anchors.centerIn: parent
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            MetricsDashboard {
                metrics: gameEngine.getMetrics()
            }
        }
    }
}
