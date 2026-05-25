import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtTextToSpeech 5.15

ApplicationWindow {
    visible: true
    width: 1024
    height: 768
    title: "Word Recognition Game"

    TextToSpeech {
        id: tts
        volume: 1.0
        pitch: 0.0
        rate: -0.2 // Slow and concise
    }

    Rectangle {
        id: background
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#e0f7fa" }
            GradientStop { position: 1.0; color: "#80deea" }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 20
            anchors.margins: 40

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Word Recognition Fun!"
                font.pixelSize: 48
                font.bold: true
                color: "#00796b"
                style: Text.Outline
                styleColor: "white"
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 50

                // Left: Word Display
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"
                    radius: 30
                    border.color: "#4db6ac"
                    border.width: 5
                    
                    Text {
                        id: wordText
                        anchors.centerIn: parent
                        text: gameEngine.currentWord
                        font.pixelSize: 120
                        font.bold: true
                        color: "#ff5722"
                        style: Text.Raised
                        styleColor: "#bf360c"
                        
                        Behavior on text {
                            SequentialAnimation {
                                NumberAnimation { target: wordText; property: "scale"; from: 1.0; to: 1.2; duration: 200 }
                                NumberAnimation { target: wordText; property: "scale"; from: 1.2; to: 1.0; duration: 200 }
                            }
                        }
                    }
                }

                // Right: Image Display
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"
                    radius: 30
                    border.color: "#4db6ac"
                    border.width: 5
                    clip: true

                    Image {
                        id: wordImage
                        anchors.fill: parent
                        anchors.margins: 20
                        source: gameEngine.currentImage
                        fillMode: Image.PreserveAspectFit
                        
                        Behavior on source {
                            NumberAnimation { target: wordImage; property: "opacity"; from: 0; to: 1; duration: 500 }
                        }
                    }
                }
            }

            // Recording Status
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 200
                height: 60
                color: gameEngine.isRecording ? "#ff1744" : "#cfd8dc"
                radius: 30
                
                Text {
                    anchors.centerIn: parent
                    text: gameEngine.isRecording ? "Listening..." : "Waiting"
                    color: "white"
                    font.pixelSize: 24
                    font.bold: true
                }
                
                SequentialAnimation on opacity {
                    running: gameEngine.isRecording
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 0.5; duration: 500 }
                    NumberAnimation { from: 0.5; to: 1.0; duration: 500 }
                }
            }
        }
    }

    // Game Logic Flow
    Timer {
        id: gameStartTimer
        interval: 2000
        running: true
        onTriggered: {
            tts.say("Welcome Steve, I would like you to read what you see");
            wordReadTimer.start();
        }
    }

    Timer {
        id: wordReadTimer
        interval: 3000 // Wait for welcome message to finish
        onTriggered: {
            readWordThreeTimes(0);
        }
    }

    function readWordThreeTimes(count) {
        if (count < 3) {
            tts.say(gameEngine.currentWord);
            var delay = 1500;
            Timer.singleShot(delay, function() { readWordThreeTimes(count + 1); });
        } else {
            Timer.singleShot(1000, function() {
                tts.say("What is this?");
                Timer.singleShot(1500, function() {
                    gameEngine.startRecording();
                    // Simulate child response after 3 seconds
                    Timer.singleShot(3000, function() {
                        gameEngine.stopRecording();
                    });
                });
            });
        }
    }

    Connections {
        target: gameEngine
        onRecordingFinished: {
            tts.rate = 0.2; // Comical voice (faster/higher)
            tts.say("I can't hear you");
            tts.rate = -0.2; // Back to normal
            
            // Submit metrics
            var metrics = {
                "word": gameEngine.currentWord,
                "time_taken_ms": 3000,
                "audio_file": fileName
            };
            gameEngine.submitMetrics(metrics);
            
            // Move to next word after a delay
            Timer.singleShot(4000, function() {
                gameEngine.nextWord();
                gameStartTimer.start();
            });
        }
    }
}
