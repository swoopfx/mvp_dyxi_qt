import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

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
                // console.log("Back clicked")
                stackView.pop()
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
