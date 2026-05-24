import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Robot Talk Game"
    color: "#F0F8FF" // Light blue background, not distracting

    property string currentWord: "CAT"
    property int attemptCount: 0

    // Replay Button (Top Right)
    Button {
        id: replayButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        width: 60
        height: 60
        z: 10 // Ensure it's on top

        background: Image {
            source: "../assets/replay_button.png"
            fillMode: Image.PreserveAspectFit
        }

        onClicked: gameEngine.replayIntro()

        // Visual feedback on hover/press
        opacity: pressed ? 0.7 : 1.0
        scale: hovered ? 1.1 : 1.0
        Behavior on scale { NumberAnimation { duration: 100 } }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        // Animal Display Area
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            
            Image {
                id: animalImage
                anchors.centerIn: parent
                source: "../assets/" + gameEngine.currentAnimal + ".png"
                width: 250
                height: 250
                fillMode: Image.PreserveAspectFit

                // Talking Animation
                SequentialAnimation on scale {
                    running: gameEngine.isTalking
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.1; duration: 200 }
                    NumberAnimation { to: 1.0; duration: 200 }
                }
            }
        }

        // Interaction Area
        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 40
            spacing: 50

            // Robot/Instruction Area (Left)
            Rectangle {
                Layout.preferredWidth: 300
                Layout.preferredHeight: 150
                color: "#FFFFFF"
                radius: 15
                border.color: "#3498db"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: gameEngine.isTalking ? "Robot is talking..." : "Listen and Repeat!"
                    font.pixelSize: 24
                    color: "#2c3e50"
                }
            }

            // Word Display (Right) - Embossed and Colorful
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                color: "#ecf0f1"
                radius: 20
                
                // Embossed effect
                border.color: "#bdc3c7"
                border.width: 1
                layer.enabled: true
                
                Text {
                    id: wordText
                    anchors.centerIn: parent
                    text: currentWord
                    font.pixelSize: 80
                    font.bold: true
                    color: "#e67e22" // Vibrant orange
                    style: Text.Raised
                    styleColor: "#d35400"
                }
            }
        }

        // Control Buttons
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20
            
            Button {
                text: "Start Game"
                onClicked: gameEngine.startIntro()
            }

            Button {
                text: "Next Word"
                onClicked: {
                    currentWord = "DOG"; // Logic to cycle words
                    gameEngine.startWordExercise(currentWord);
                }
            }
        }
    }

    Component.onCompleted: {
        // Automatically start or wait for user
    }
}
