import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import RobotTalkGame 1.0

ApplicationWindow {
    id: window
    width: 1024
    height: 768
    visible: true
    title: qsTr("Robot Talk Speech Game (Qt6 whisper.cpp Integration)")
    color: "#FDFCF0" 

    // Core companion properties
    property var activeAnimalIntro: "Hi I am Hermit! Let's say some words with offline Whisper.cpp AI translation."
    property string activeWord: "CAT"
    property var letterElements: ["C", "A", "T"]
    property var ipas: ["/k/", "/æ/", "/t/"]
    property int currentTrialStep: 0
    property bool isRecording: false

    // Instantiate SpeechEngine linking directly to whisper.cpp core routines
    SpeechEngine {
        id: speechEngine
        
        onWhisperStatusChanged: {
            console.log("Whisper context updated. System loaded state: " + isWhisperLoaded)
            modelStatusText.text = isWhisperLoaded ? "Models Mounted Successfully" : "Running on Simulator Mode"
        }

        onNetworkErrorOccurred: {
            errorPopup.errorMessage = errorMessage
            errorPopup.open()
        }
    }

    Component.onCompleted: {
        // Attempt loading local tiny GGML linguistic binaries on launch
        speechEngine.loadWhisperModel("models/ggml-tiny.en.bin")
    }

    // Grid Dot Pattern styled layout
    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = "#E2E8F0";
            for (var x = 12; x < width; x += 24) {
                for (var y = 12; y < height; y += 24) {
                    ctx.beginPath();
                    ctx.arc(x, y, 1.2, 0, 2 * Math.PI);
                    ctx.fill();
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 20

        // Top Educational Stats Ribbon
        Rectangle {
            Layout.fillWidth: true
            height: 80
            radius: 20
            color: "#B3FFFFFF"
            border.color: "white"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15

                RowLayout {
                    spacing: 12
                    Rectangle {
                        width: 44; height: 44
                        radius: 12
                        color: "#FACC15"
                        Text { text: "⭐"; font.pixelSize: 22; anchors.centerIn: parent }
                    }
                    Column {
                        Text { text: qsTr("Live Sound Analytics (Whiser.cpp)"); font.bold: true; font.pixelSize: 15; color: "#0F172A" }
                        Text { 
                            id: modelStatusText
                            text: qsTr("Attaching Audio Model Weights...")
                            font.bold: true; font.pixelSize: 11; color: "#94A3B8" 
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                RowLayout {
                    spacing: 25
                    Column {
                        horizontalAlignment: Text.AlignRight
                        Text { text: qsTr("ACCURACY"); font.bold: true; font.pixelSize: 10; color: "#94A3B8" }
                        Text { text: speechEngine.latestAccuracy + "%"; font.bold: true; font.pixelSize: 17; color: "#10B981" }
                    }
                    Rectangle { width: 1; height: 35; color: "#E2E8F0" }
                    Column {
                        horizontalAlignment: Text.AlignRight
                        Text { text: qsTr("FLUENCY"); font.bold: true; font.pixelSize: 10; color: "#94A3B8" }
                        Text { text: speechEngine.latestFluency + "%"; font.bold: true; font.pixelSize: 17; color: "#3B82F6" }
                    }
                }
            }
        }

        // Main Interaction Section
        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 28

            // Left Side: Mini cartoon puppet representable model
            ColumnLayout {
                Layout.preferredWidth: 420
                Layout.fillHeight: true
                spacing: 15

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 24
                    color: "white"
                    border.color: "#E2E8F0"
                    border.width: 2

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 20

                        Rectangle {
                            width: 220; height: 220
                            radius: 110
                            color: "#E0F2FE"
                            border.color: "white"
                            border.width: 6

                            Text {
                                text: "🦀"
                                font.pixelSize: 120
                                anchors.centerIn: parent
                            }

                            // Interactive talking animation sequences
                            SequentialAnimation on y {
                                running: isRecording
                                loops: Animation.Infinite
                                PropertyAnimation { to: -15; duration: 250; easing.type: Easing.InOutQuad }
                                PropertyAnimation { to: 0; duration: 250; easing.type: Easing.InOutQuad }
                            }
                        }

                        // Dialogue Subtitle Bubble
                        Rectangle {
                            width: 320; height: 110
                            radius: 16
                            color: "#EFF6FF"
                            border.color: "#BFDBFE"
                            border.width: 2

                            Text {
                                anchors.fill: parent
                                anchors.margins: 12
                                text: activeAnimalIntro
                                font.pixelSize: 12
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                                color: "#1E3A8A"
                            }
                        }
                    }
                }
            }

            // Right Side: Embossed letters displaying core segments + Whisper transcription feed
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 24

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 30
                    color: "#66FFFFFF"
                    border.color: "white"
                    border.width: 2

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 35

                        Text {
                            text: qsTr("LISTEN & SPEAK THE BLENDED SYLLABLES")
                            font.bold: true
                            font.pixelSize: 12
                            font.letterSpacing: 2
                            color: "#94A3B8"
                            anchors.horizontalCenter: parent
                        }

                        // Syllables
                        RowLayout {
                            spacing: 15
                            anchors.horizontalCenter: parent

                            Repeater {
                                model: letterElements.length
                                Rectangle {
                                    width: 100; height: 130
                                    radius: 18
                                    color: model === 0 ? "#EC4899" : (model === 1 ? "#3B82F6" : "#EAB308")
                                    border.color: "#1A000000"
                                    border.width: 2

                                    Rectangle {
                                        width: parent.width; height: 8
                                        color: model === 0 ? "#9D174D" : (model === 1 ? "#1E40AF" : "#854D0E")
                                        anchors.bottom: parent.bottom
                                        radius: 18
                                    }

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 6
                                        Text {
                                            text: letterElements[model]
                                            color: "white"
                                            font.bold: true
                                            font.pixelSize: 55
                                            anchors.horizontalCenter: parent
                                        }
                                        Text {
                                            text: ipas[model]
                                            color: "#B3FFFFFF"
                                            font.pixelSize: 13
                                            anchors.horizontalCenter: parent
                                        }
                                    }
                                }
                            }
                        }

                        // Live audio transcription response box (Whisper output)
                        Rectangle {
                            Layout.fillWidth: true
                            width: 420; height: 60
                            radius: 14
                            color: "#F8FAFC"
                            border.color: "#E2E8F0"
                            anchors.horizontalCenter: parent

                            Column {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { 
                                    text: "WHISPER STT RECOGNITION FEED:"
                                    font.bold: true; font.pixelSize: 9
                                    color: "#94A3B8"
                                    anchors.horizontalCenter: parent
                                }
                                Text { 
                                    text: "\"" + speechEngine.transcription + "\""
                                    font.bold: true; font.pixelSize: 14; font.family: "Courier"
                                    color: "#0F172A"
                                    anchors.horizontalCenter: parent
                                }
                            }
                        }

                        // Microphone feedback controls
                        ColumnLayout {
                            spacing: 12
                            anchors.horizontalCenter: parent

                            Button {
                                id: recordButton
                                Layout.preferredWidth: 80
                                Layout.preferredHeight: 80
                                background: Rectangle {
                                    radius: 40
                                    color: isRecording ? "#DC2626" : "#EF4444"
                                    border.color: "white"
                                    border.width: 4
                                }
                                onClicked: {
                                    isRecording = !isRecording
                                    if (isRecording) {
                                        speechEngine.startVoiceRecording()
                                    } else {
                                        speechEngine.stopVoiceRecordingAndAnalyze(activeWord, currentTrialStep)
                                        currentTrialStep = (currentTrialStep + 1) % 5
                                    }
                                }
                            }

                            Text {
                                text: isRecording ? qsTr("RECORDING SOUND... Speak the letters!") : qsTr("Tap to record child repetition")
                                color: isRecording ? "#DC2626" : "#64748B"
                                font.bold: true; font.pixelSize: 12
                                anchors.horizontalCenter: parent
                            }
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: errorPopup
        property string errorMessage: ""
        width: 320; height: 180
        anchors.centerIn: parent
        modal: true
        closePolicy: Popup.CloseOnEscape
        Rectangle {
            anchors.fill: parent
            color: "#FEF2F2"
            border.color: "#FECACA"
            radius: 15
            Column {
                anchors.centerIn: parent
                spacing: 12
                Text { text: "⚠️ Simulated Device Warning!"; font.bold: true; color: "#991B1B" }
                Text { text: errorPopup.errorMessage; font.pixelSize: 11; width: 280; wrapMode: Text.WordWrap }
                Button {
                    text: "Acknowledge"
                    onClicked: errorPopup.close()
                }
            }
        }
    }
}
