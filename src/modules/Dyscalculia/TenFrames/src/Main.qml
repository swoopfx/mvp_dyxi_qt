import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15

ApplicationWindow {
    visible: true
    width: 1024
    height: 768
    title: "Ten-Frame Number Bonds"

    background: Image {
        source: "../assets/images/game_background.png"
        fillMode: Image.PreserveAspectCrop
    }

    Audio {
        id: bgMusic
        source: "../assets/audio/background_music.wav"
        loops: Audio.Infinite
        autoPlay: true
        volume: 0.5
    }

    Audio {
        id: successSound
        source: "../assets/audio/success.wav"
    }

    Audio {
        id: failureSound
        source: "../assets/audio/failure.wav"
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: startScreen
    }

    Component {
        id: startScreen
        Item {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "Ten-Frame Adventure!"
                    font.pixelSize: 64
                    font.bold: true
                    color: "#2c3e50"
                    Layout.alignment: Qt.AlignHCenter
                }

                ComboBox {
                    id: difficultySelector
                    model: ["Easy", "Hard"]
                    currentIndex: 0
                    Layout.alignment: Qt.AlignHCenter
                    onCurrentTextChanged: gameEngine.difficulty = currentText
                }

                Button {
                    text: "Start Game"
                    font.pixelSize: 32
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: {
                        gameEngine.startNewGame()
                        stackView.push(gameScreen)
                    }
                }
            }
        }
    }

    Component {
        id: gameScreen
        Item {
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40
                spacing: 30

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "Question: " + gameEngine.currentQuestionValue + " + ? = 10"
                        font.pixelSize: 48
                        font.bold: true
                        color: "#34495e"
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "Score: " + gameEngine.score
                        font.pixelSize: 32
                        color: "#e67e22"
                    }
                }

                TenFrameBoard {
                    id: board
                    Layout.alignment: Qt.AlignHCenter
                    initialValue: gameEngine.currentQuestionValue
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20
                    Button {
                        text: "Check Answer"
                        font.pixelSize: 24
                        onClicked: {
                            if (gameEngine.checkAnswer(board.placedCount)) {
                                successSound.play()
                                board.reset()
                                gameEngine.nextQuestion()
                            } else {
                                failureSound.play()
                            }
                        }
                    }
                    Button {
                        text: "End Session"
                        onClicked: stackView.push(summaryScreen)
                    }
                }
            }
        }
    }

    Component {
        id: summaryScreen
        Item {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "Game Summary"
                    font.pixelSize: 48
                    font.bold: true
                }

                Text { text: "Accuracy: " + (metricsEngine.accuracy * 100).toFixed(1) + "%"; font.pixelSize: 24 }
                Text { text: "Math Speed Index: " + metricsEngine.mentalMathSpeedIndex.toFixed(2); font.pixelSize: 24 }
                Text { text: "Concentration: " + metricsEngine.concentrationIndex.toFixed(2); font.pixelSize: 24 }
                Text { text: "Number Sense: " + metricsEngine.numberSenseIndex.toFixed(2); font.pixelSize: 24 }

                Button {
                    text: "Download JSON Data"
                    onClicked: {
                        sessionLogger.exportToJson("/home/ubuntu/ten_frame_game/session_data.json")
                        console.log("Data exported to session_data.json")
                    }
                }

                Button {
                    text: "Play Again"
                    onClicked: stackView.pop(null)
                }
            }
        }
    }
}
