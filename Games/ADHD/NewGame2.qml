// SmartPlayground.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: window
    width: 1280
    height: 800
    visible: true
    title: "Smart ADHD Playground"

    property int activeTime: 0
    property int idleTime: 0
    property int correctDrops: 0
    property int wrongDrops: 0
    property bool userActive: false

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (userActive)
                activeTime++
            else
                idleTime++
            userActive = false
        }
    }

    RowLayout {
        anchors.fill: parent

        // ================= NAVIGATION =================
        Rectangle {
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            color: "#1E88E5"

            Column {
                anchors.centerIn: parent
                spacing: 20

                Button {
                    text: "⬅ Back"
                }

                Button {
                    text: "🔊 Read"
                    onClicked: {
                        ttsEngine.speak("Drag the word to the correct box")
                    }
                }

                Button {
                    text: "❓ Help"
                }

                Button {
                    text: "📊 Show Focus"
                    onClicked: {
                        focusPopup.open()
                    }
                }
            }
        }

        // ================= GAME AREA =================
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#F9FBFF"

            Text {
                text: "Drag the Animal to the Correct Habitat"
                font.pixelSize: 32
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 20
            }

            // DRAG ITEM
            Rectangle {
                id: draggable
                width: 150
                height: 80
                radius: 10
                color: "#FFD54F"
                anchors.centerIn: parent

                Text {
                    anchors.centerIn: parent
                    text: "Lion"
                    font.pixelSize: 24
                }

                Drag.active: dragArea.drag.active

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    onPressed: userActive = true
                }
            }

            // DROP ZONE - SAVANNAH (Correct)
            Rectangle {
                id: correctZone
                width: 200
                height: 150
                color: "#C8E6C9"
                radius: 10
                anchors.left: parent.left
                anchors.leftMargin: 200
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 100

                Text {
                    anchors.centerIn: parent
                    text: "Savannah"
                }

                DropArea {
                    anchors.fill: parent
                    onDropped: {
                        correctDrops++
                        userActive = true
                        draggable.x = parent.x
                        draggable.y = parent.y
                    }
                }
            }

            // DROP ZONE - OCEAN (Wrong)
            Rectangle {
                id: wrongZone
                width: 200
                height: 150
                color: "#BBDEFB"
                radius: 10
                anchors.right: parent.right
                anchors.rightMargin: 200
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 100

                Text {
                    anchors.centerIn: parent
                    text: "Ocean"
                }

                DropArea {
                    anchors.fill: parent
                    onDropped: {
                        wrongDrops++
                        userActive = true
                    }
                }
            }
        }
    }

    // ================= FOCUS ANALYTICS POPUP =================
    Popup {
        id: focusPopup
        width: 400
        height: 350
        modal: true
        anchors.centerIn: parent

        Rectangle {
            anchors.fill: parent
            radius: 20
            color: "white"

            Column {
                anchors.centerIn: parent
                spacing: 10

                property real accuracy: (correctDrops + wrongDrops) === 0 ? 0 :
                    correctDrops / (correctDrops + wrongDrops)

                property real focusScore:
                    ((activeTime / (activeTime + idleTime + 1)) * accuracy) * 100

                Text { text: "Focus Report"; font.pixelSize: 26; font.bold: true }
                Text { text: "Active Time: " + activeTime + " sec" }
                Text { text: "Idle Time: " + idleTime + " sec" }
                Text { text: "Correct: " + correctDrops }
                Text { text: "Wrong: " + wrongDrops }
                Text { text: "Focus Score: " + focusScore.toFixed(1) + "%" }

                Button {
                    text: "Close"
                    onClicked: focusPopup.close()
                }
            }
        }
    }
}
