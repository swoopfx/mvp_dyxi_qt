// PlaygroundPage.qml
import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Page {
    id: window
    visible: true
    // width: 1280
    // height: 800
    // title: "Game Playground"

    Rectangle {
        anchors.fill: parent
        color: "#F4F9FF"

        RowLayout {
            anchors.fill: parent
            spacing: 20

            // ==============================
            // LEFT NAVIGATION PANEL
            // ==============================
            LeftNavigation{

                z:10


            }

            // ==============================
            // MAIN PLAYGROUND AREA
            // ==============================

            Playground{

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
