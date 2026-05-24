import QtQuick
import QtQuick.Controls
import TinyPolkaDot

import QtMultimedia

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Tiny Polka Dot")
    
    Image {
        anchors.fill: parent
        source: "background.png"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.6
    }

    MediaPlayer {
        id: musicPlayer
        source: "background_music.mp3"
        audioOutput: AudioOutput {}
        loops: MediaPlayer.Infinite
    }

    Component.onCompleted: musicPlayer.play()

    GameEngine {
        id: engine
        onGameFinished: (summary) => {
            console.log("Game Finished: " + JSON.stringify(summary))
        }
    }

    property var selectedCards: []
    property var cardModel: []
    property int startTime: 0

    function setupGame(difficulty) {
        engine.startGame(difficulty)
        var values = []
        var maxVal = difficulty === "Easy" ? 5 : (difficulty === "Medium" ? 8 : 10)
        for (var i = 0; i <= maxVal; i++) {
            values.push(i)
            values.push(i) // Pairs
        }
        // Shuffle
        for (var j = values.length - 1; j > 0; j--) {
            var k = Math.floor(Math.random() * (j + 1));
            var temp = values[j];
            values[j] = values[k];
            values[k] = temp;
        }
        cardModel = values
        gameBoard.model = cardModel
        startTime = Date.now()
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Row {
            width: parent.width
            spacing: 20
            Text {
                text: "Tiny Polka Dot"
                font.pixelSize: 32
                color: "#FF69B4"
                font.bold: true
            }
            Button { text: "Easy"; onClicked: setupGame("Easy") }
            Button { text: "Medium"; onClicked: setupGame("Medium") }
            Button { text: "Hard"; onClicked: setupGame("Hard") }
            
            Item { Layout.fillWidth: true }
            
            Text { text: "Score: " + engine.score; font.pixelSize: 20 }
            Text { text: "Accuracy: " + engine.accuracy.toFixed(1) + "%"; font.pixelSize: 20 }
        }

        GridView {
            id: gameBoard
            width: parent.width
            height: parent.height - 100
            cellWidth: 140
            cellHeight: 180
            delegate: Card {
                value: modelData
                colorName: index % 2 === 0 ? "teal" : "purple"
                onClicked: {
                    if (faceUp || matched || selectedCards.length >= 2) return
                    faceUp = true
                    selectedCards.push(this)
                    
                    if (selectedCards.length === 2) {
                        var timeTaken = Date.now() - startTime
                        if (selectedCards[0].value === selectedCards[1].value) {
                            engine.recordMatch(true, timeTaken)
                            selectedCards[0].matched = true
                            selectedCards[1].matched = true
                            selectedCards = []
                        } else {
                            engine.recordMatch(false, timeTaken)
                            timer.start()
                        }
                        startTime = Date.now()
                    }
                }
            }
        }
    }

    Timer {
        id: timer
        interval: 1000
        onTriggered: {
            selectedCards[0].faceUp = false
            selectedCards[1].faceUp = false
            selectedCards = []
        }
    }

    Button {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        text: "View Dashboard"
        onClicked: dashboard.visible = true
    }

    Dashboard {
        id: dashboard
        anchors.fill: parent
        visible: false
        engine: engine
    }
}
