import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    visible: true
    // width: 900
    // height: 600
    // title: "Alphabet Learning Game"

    property string targetLetter: ""
    property int score: 0
    property var letters: [
        "A","B","C","D","E","F","G","H"

    ]

    function pickRandomLetter(){
        var index = Math.floor(Math.random() * letters.length)
        targetLetter = letters[index]
    }

    Component.onCompleted: pickRandomLetter()

    Rectangle {
        anchors.fill: parent
        color: "#F7F9FC"

        Column {
            anchors.centerIn: parent
            spacing: 30

            Text {
                text: "Find the letter:"
                font.pixelSize: 32
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: targetLetter
                font.pixelSize: 180
                color: "#FF6B6B"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: feedback
                text: ""
                font.pixelSize: 28
                color: "green"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            GridLayout {
                columns: 6
                rowSpacing: 20
                columnSpacing: 20
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: letters

                    Rectangle {
                        width: 200
                        height: 200
                        radius: 20
                        color: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.8)

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: 80
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {

                                if(modelData === targetLetter){

                                    feedback.text = "🎉 Correct!"
                                    score += 1

                                    pickRandomLetter()

                                } else {

                                    feedback.text = "❌ Try Again"

                                }
                            }
                        }

                        Behavior on scale {
                            NumberAnimation { duration: 120 }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: parent.scale = 1.1
                            onExited: parent.scale = 1
                        }
                    }
                }
            }

            Text {
                text: "Score: " + score
                font.pixelSize: 26
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
