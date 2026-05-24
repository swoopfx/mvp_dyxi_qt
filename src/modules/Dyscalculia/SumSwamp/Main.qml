import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    width: 1280
    height: 720
    visible: true
    title: "Sum Swamp Adventure"

    property int currentPos: 0
    property var boardPath: [
        {x: 150, y: 200}, {x: 250, y: 180}, {x: 350, y: 170}, {x: 450, y: 180},
        {x: 550, y: 220}, {x: 600, y: 320}, {x: 650, y: 420}, {x: 700, y: 520},
        {x: 800, y: 550}, {x: 900, y: 530}, {x: 1000, y: 500}, {x: 1100, y: 600}
    ]
    
    property string currentDifficulty: "Frog"
    property int consecutiveCorrect: 0

    Rectangle {
        id: mainContainer
        anchors.fill: parent
        color: "#a8e6cf" // Light swamp green

        Image {
            id: background
            anchors.fill: parent
            source: "../assets/images/swamp_board.png"
            fillMode: Image.PreserveAspectCrop
        }

        // Game Character
        Image {
            id: player
            width: 100
            height: 100
            source: "../assets/images/frog_player.png"
            x: boardPath[currentPos].x - width/2
            y: boardPath[currentPos].y - height/2
            
            Behavior on x { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
            Behavior on y { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
        }

        // Dice Panel
        Rectangle {
            id: dicePanel
            width: 300
            height: 150
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 20
            color: Qt.rgba(1, 1, 1, 0.8)
            radius: 20
            border.color: "#3d5a80"
            border.width: 3

            RowLayout {
                anchors.centerIn: parent
                spacing: 20
                
                Text { id: die1; text: "5"; font.pixelSize: 40; font.bold: true; color: "#ef476f" }
                Text { id: op; text: "+"; font.pixelSize: 40; font.bold: true; color: "#06d6a0" }
                Text { id: die2; text: "2"; font.pixelSize: 40; font.bold: true; color: "#118ab2" }
                Text { text: "="; font.pixelSize: 40; font.bold: true }
                
                TextField {
                    id: answerInput
                    width: 60
                    font.pixelSize: 30
                    horizontalAlignment: TextInput.AlignHCenter
                    validator: IntValidator { bottom: -20; top: 50 }
                    onAccepted: checkAnswer()
                }
            }
        }

        // Difficulty Selector
        Row {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 20
            spacing: 10
            
            Repeater {
                model: ["Tadpole", "Frog", "Gator"]
                Button {
                    text: modelData
                    onClicked: {
                        currentDifficulty = modelData
                        gameEngine.difficulty = modelData
                        rollDice()
                    }
                    background: Rectangle {
                        color: currentDifficulty === text ? "#ffd166" : "#ffffff"
                        radius: 5
                    }
                }
            }
        }

        // Stats Overlay
        Rectangle {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20
            width: 220
            height: 120
            color: Qt.rgba(0, 0, 0, 0.6)
            radius: 15

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                Text { text: "Accuracy: " + (gameEngine.accuracy * 100).toFixed(1) + "%"; color: "white"; font.pixelSize: 16 }
                Text { text: "Speed: " + gameEngine.averageSpeed.toFixed(2) + "s"; color: "white"; font.pixelSize: 16 }
                Text { text: "Level: " + currentDifficulty; color: "#06d6a0"; font.pixelSize: 16; font.bold: true }
            }
        }

        // Task Overlay (Complementary Tasks)
        Rectangle {
            id: taskOverlay
            anchors.fill: parent
            visible: false
            color: Qt.rgba(0, 0, 0, 0.8)
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 30
                Text { id: taskText; color: "white"; font.pixelSize: 32; font.bold: true }
                TextField {
                    id: taskInput
                    width: 100
                    font.pixelSize: 30
                    horizontalAlignment: TextInput.AlignHCenter
                    onAccepted: {
                        taskOverlay.visible = false
                        rollDice()
                    }
                }
                Button {
                    text: "Submit"
                    onClicked: {
                        taskOverlay.visible = false
                        rollDice()
                    }
                }
            }
        }
    }

    function checkAnswer() {
        let val = parseInt(answerInput.text)
        gameEngine.processAnswer(parseInt(die1.text), op.text, parseInt(die2.text), val)
        
        if (val === (op.text === "+" ? parseInt(die1.text) + parseInt(die2.text) : parseInt(die1.text) - parseInt(die2.text))) {
            currentPos = Math.min(currentPos + val, boardPath.length - 1)
            // Roll new dice
            rollDice()
        }
        answerInput.clear()
    }

    function rollDice() {
        let maxNum = 6
        if (currentDifficulty === "Tadpole") {
            maxNum = 5
            op.text = "+"
        } else if (currentDifficulty === "Gator") {
            maxNum = 12
            op.text = Math.random() > 0.5 ? "+" : "-"
        } else {
            op.text = Math.random() > 0.5 ? "+" : "-"
        }
        
        die1.text = Math.floor(Math.random() * maxNum) + 1
        die2.text = Math.floor(Math.random() * maxNum) + 1
        
        // Ensure no negative results for beginners
        if (op.text === "-" && parseInt(die1.text) < parseInt(die2.text)) {
            let temp = die1.text
            die1.text = die2.text
            die2.text = temp
        }
    }

    // Complementary Task: Number Sense Challenge
    function showNumberSenseTask() {
        taskOverlay.visible = true
        taskText.text = "Find the missing number: " + die1.text + " + ? = " + (parseInt(die1.text) + 5)
    }

    Component.onCompleted: {
        gameEngine.startSession()
        rollDice()
    }
}
