import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15

Page {
    visible: true
    width: 900
    height: 600
    title: "Phonics Pop!"

    property string correctLetter: "B"

    Rectangle {
        anchors.fill: parent
        color: "#E8F6FF"

        Column {
            anchors.centerIn: parent
            spacing: 40

            Text {
                id: instruction
                text: "Tap the letter that makes this sound"
                font.pixelSize: 32
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            Button {
                text: "🔊 Play Sound"
                font.pixelSize: 28
                onClicked: phonicsSound.play()
            }

            Row {
                spacing: 40
                anchors.horizontalCenter: parent.horizontalCenter

                LetterButton { letter: "B" }
                LetterButton { letter: "D" }
                LetterButton { letter: "P" }
            }

            Button {
                text: "Next"
                font.pixelSize: 24
                onClicked: resetGame()
            }
        }

        SoundEffect {
            id: phonicsSound
            source: "sounds/b_sound.wav"
        }

        SoundEffect {
            id: correctSound
            source: "sounds/correct.wav"
        }

        ParticleSystem {
            id: particles
        }

        Emitter {
            system: particles
            width: parent.width
            height: parent.height
            emitRate: celebration ? 80 : 0
            lifeSpan: 2000
            velocity: AngleDirection { angle: 270; magnitude: 150 }
            size: 16
        }

        property bool celebration: false

        function showCelebration() {
            celebration = true
            correctSound.play()
        }

        function resetGame() {
            celebration = false
        }

        Component {
            id: letterButtonComponent
        }

        Component {
            id: letterButton

            Rectangle {
                width: 150
                height: 150
                radius: 20
                color: "#FFD966"

                property string letter: ""

                Text {
                    anchors.centerIn: parent
                    text: letter
                    font.pixelSize: 72
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (letter === correctLetter) {
                            showCelebration()
                        }
                    }
                }
            }
        }
    }
}
