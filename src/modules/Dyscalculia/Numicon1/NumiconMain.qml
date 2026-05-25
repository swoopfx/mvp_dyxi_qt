import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import  Dyscalculia.Numicon1

Page {
    id: window
    visible: true
    width: 800
    height: 600
    title: "Numicon Adventure"
    // color: "#f0f8ff"

    property int difficulty: 1
    property var currentTask: null

    GameEnginen{
        id:gameEngine
    }

    MetricTracker{

        id:metricTracker
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        // Header
        Text {
            text: "Numicon Adventure"
            font.pixelSize: 32
            font.bold: true
            color: "#2e8b57"
            Layout.alignment: Qt.AlignHCenter
        }

        // Metrics Display
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20
            Text { text: "Correct: " + metricTracker.correctCount; font.bold: true; color: "green" }
            Text { text: "Failed: " + metricTracker.failedCount; font.bold: true; color: "red" }
            Text { text: "Concentration: " + (metricTracker.concentrationIndex * 100).toFixed(1) + "%" }
        }

        // Level Selection
        RowLayout {
            spacing: 10
            Layout.alignment: Qt.AlignHCenter
            Button { text: "Level 1"; onClicked: { difficulty = 1; nextTask() } }
            Button { text: "Level 2"; onClicked: { difficulty = 2; nextTask() } }
            Button { text: "Level 3"; onClicked: { difficulty = 3; nextTask() } }
        }

        // Game Area
        Rectangle {
            width: 400
            height: 300
            color: "white"
            radius: 20
            border.color: "#ddd"
            
            Column {
                anchors.centerIn: parent
                spacing: 20
                
                Text {
                    id: taskText
                    text: currentTask ? "Find the shape for: " + currentTask.target : "Select a level to start!"
                    font.pixelSize: 24
                }

                NumiconShape {
                    id: targetShape
                    value: currentTask ? currentTask.target : 1
                    visible: currentTask !== null
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // Options
        Flow {
            id: optionsFlow
            width: 600
            spacing: 10
            Layout.alignment: Qt.AlignHCenter
            
            Repeater {
                model: 10
                NumiconShape {
                    value: index + 1
                    width: 60; height: 60
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: checkAnswer(index + 1)
                    }
                }
            }
        }
        
        Button {
            text: "Save Session Log"
            Layout.alignment: Qt.AlignHCenter
            onClicked: metricTracker.saveLog("/home/ubuntu/numicon_session.json")
        }
    }

    function nextTask() {
        currentTask = gameEngine.generateTask(difficulty)
        metricTracker.logEvent("question_asked", {
            "target": currentTask.target,
            "difficulty": difficulty
        })
    }

    function checkAnswer(val) {
        if (!currentTask) return
        
        let correct = gameEngine.checkAnswer(currentTask.target, val)
        
        metricTracker.logEvent("answer_submitted", {
            "target": currentTask.target,
            "input": val,
            "correct": correct,
            "difficulty": difficulty
        })

        if (correct) {
            nextTask()
        } else {
            // In a real game, we might show a hint or shake the screen
        }
    }
}
