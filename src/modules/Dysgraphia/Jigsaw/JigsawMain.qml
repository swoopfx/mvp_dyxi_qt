import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Jigsaw 1.0

Page {
    id: root
    anchors.fill: parent
    // width: 1024
    // height: 768
    // visible: true
    // title: qsTr("NeuroPlay Qt6 Jigsaw Diagnostic Simulator")
    // color: "#F8FAFC"

    // Instantiate Modern C++ ADHD Analytics Core Node
    CognitiveEngine {
        id: telemetryCore
        patientAge: 5
        gridDimension: 2
        activeShapeMode: "jigsaw"

        onTargetPlacedSuccess: pieceId => {
            console.log("C++ Engine slot snap verified for index: " + pieceId);
            statusTray.statusMessage = "Piece Snapped Properly";
        }
        onPlacementErrorRecorded: errorCode => {
            console.warn("C++ Event: Incorrect snap pattern triggers coordinates check.");
            statusTray.statusMessage = "Diagnostic: Invalid coordinates pattern.";
        }
        onFatigueDetected: fatigueIndex => {
            console.warn("ADHD Fatigue flag raised! Level: " + fatigueIndex.toFixed(3));
            statusTray.statusMessage = "Cognitive threshold exceeded: Recommended Break.";
        }
        onPuzzleFinished: telemetryJson => {
            console.log("🧩 Native Diagnostic Medical Record Compiled successfully: " + telemetryJson);
            logStream.text += "[C++ Report] Completed! JSON Metrics:\n" + telemetryJson + "\n";
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Header Title Bar
        Rectangle {
            Layout.fillWidth: true
            height: 70
            color: "#FFFFFF"
            radius: 16
            border.color: "#E2E8F0"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text {
                    text: "📱 NeuroPlay Diagnostic Slate Simulator"
                    font.family: "Inter"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#0F172A"
                }

                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    color: "#EEF2F6"
                    radius: 8
                    implicitWidth: 160
                    implicitHeight: 32
                    Text {
                        anchors.centerIn: parent
                        text: "Shape mode: " + telemetryCore.activeShapeMode.toUpperCase()
                        font.family: "Space Grotesk"
                        font.pixelSize: 11
                        font.bold: true
                        color: "#4F46E5"
                    }
                }
            }
        }

        // Playroom Grid Frame
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 24

            // Jigsaw Board Section
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 480
                color: "#FFFFFF"
                radius: 24
                border.color: "#E2E8F0"
                border.width: 1

                JigsawGrid {
                    id: boardGrid
                    anchors.centerIn: parent
                    gridSize: 2
                    pieceShape: "jigsaw"
                    sourceImage: "qrc:/assets/koala.png"
                    engineBridge: telemetryCore
                }
            }

            // Realtime Diagnostics Feed Sidepanel
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#0F172A"
                radius: 24

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 12

                    Text {
                        text: "💻 Qt C++ Engine Console Output"
                        color: "#34D399"
                        font.family: "JetBrains Mono"
                        font.bold: true
                        font.pixelSize: 12
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        TextArea {
                            id: logStream
                            readOnly: true
                            text: "Process Root initialized.\n[C++] Connect Signal connect(&device, &Tablet::dragDropEvent, &telemetryCore, &CognitiveEngine::calcJitter);\n[QML] Native Jigsaw Grid shape set to: " + telemetryCore.activeShapeMode + "\n"
                            color: "#E2E8F0"
                            font.family: "JetBrains Mono"
                            font.pixelSize: 11
                        }
                    }
                }
            }
        }
    }
}
