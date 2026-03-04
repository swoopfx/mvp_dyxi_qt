// PlaygroundPage.qml
import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Page {
    id: window
    visible: true
    width: 1280
    height: 800
    // title: "Game Playground"

    Rectangle {
        anchors.fill: parent
        color: "#F4F9FF"

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // ==============================
            // LEFT NAVIGATION PANEL
            // ==============================
            Rectangle {
                id: navPanel
                Layout.preferredWidth: 250
                Layout.fillHeight: true
                color: "#1E88E5"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 30

                    // Back Button
                    Button {
                        text: "⬅ Back"
                        font.pixelSize: 22
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 70

                        onClicked: {
                            console.log("Back clicked")
                            // StackView.pop() or navigation logic
                        }
                    }

                    // Text-to-Speech Button
                    Button {
                        text: "🔊 Read"
                        font.pixelSize: 22
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 70

                        onClicked: {
                            console.log("TTS clicked")
                            // Call C++ TTS bridge
                            ttsEngine.speak("Welcome to the playground")
                        }
                    }

                    // Help Button
                    Button {
                        text: "❓ Help"
                        font.pixelSize: 22
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 70

                        onClicked: {
                            helpPopup.open()
                        }
                    }
                }
            }

            // ==============================
            // MAIN PLAYGROUND AREA
            // ==============================
            Rectangle {
                id: playgroundArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#FFFFFF"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 20

                    Text {
                        text: "🎮 Game Playground"
                        font.pixelSize: 40
                        font.bold: true
                        color: "#333"
                    }

                    Rectangle {
                        width: 700
                        height: 450
                        radius: 20
                        color: "#E3F2FD"
                        border.color: "#90CAF9"
                        border.width: 3

                        Text {
                            anchors.centerIn: parent
                            text: "Game Content Appears Here"
                            font.pixelSize: 24
                            color: "#555"
                        }
                    }
                }
            }
        }
    }

    // ==============================
    // HELP POPUP
    // ==============================
    Popup {
        id: helpPopup
        width: 400
        height: 300
        modal: true
        focus: true
        anchors.centerIn: parent

        Rectangle {
            anchors.fill: parent
            radius: 20
            color: "white"

            Column {
                anchors.centerIn: parent
                spacing: 15

                Text {
                    text: "Need Help?"
                    font.pixelSize: 26
                    font.bold: true
                }

                Text {
                    text: "Tap Read to hear instructions.\nUse Back to return."
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Button {
                    text: "Close"
                    onClicked: helpPopup.close()
                }
            }
        }
    }
}
