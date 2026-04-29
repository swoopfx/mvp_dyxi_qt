import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Particles 2.15

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 768
    title: qsTr("Children's Learning Playground")

    // Define child-friendly colors
    readonly property color menuBgColor: "#FFEB3B" // Bright Yellow
    readonly property color canvasBgColor: "#FDF5E6" // Old Lace (Paper-like)
    readonly property color buttonColor: "#4CAF50" // Green
    readonly property color accentColor: "#FF5722" // Deep Orange

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Menu Column
        Rectangle {
            id: menuColumn
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width / 9
            color: menuBgColor
            z: 2

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 20

                // Back Button
                Button {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 0.8
                    Layout.preferredHeight: width
                    background: Rectangle {
                        radius: 15
                        color: parent.pressed ? "#D4C100" : "#FFFFFF"
                        border.color: "#333"
                        border.width: 2
                    }
                    contentItem: Text {
                        text: "⬅"
                        font.pixelSize: 40
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#333"
                    }
                    onClicked: console.log("Back Clicked")
                }

                // Home Button
                Button {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 0.8
                    Layout.preferredHeight: width
                    background: Rectangle {
                        radius: 15
                        color: parent.pressed ? "#D4C100" : "#FFFFFF"
                        border.color: "#333"
                        border.width: 2
                    }
                    contentItem: Text {
                        text: "🏠"
                        font.pixelSize: 40
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#333"
                    }
                    onClicked: console.log("Home Clicked")
                }

                Item { Layout.fillHeight: true } // Spacer
            }
        }

        // Main Canvas Area
        Rectangle {
            id: canvasArea
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: canvasBgColor
            clip: true

            // Particle System for Paper/Scribble Effect
            ParticleSystem {
                id: sys
            }

            Emitter {
                id: emitter
                system: sys
                anchors.fill: parent
                emitRate: 5
                lifeSpan: 5000
                size: 16
                sizeVariation: 8
                velocity: AngleDirection {
                    angle: 90
                    angleVariation: 360
                    magnitude: 2
                }
            }

            // Particle effect to simulate paper texture/scribbles
            ImageParticle {
                system: sys
                // Using a simple built-in dot if the resource isn't available
                source: "image://particles/star"
                color: "#D2B48C"
                colorVariation: 0.1
                opacity: 0.1
                entryEffect: ImageParticle.Fade
            }

            // Canvas drawing area for actual scribbling
            Canvas {
                id: drawingCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.lineWidth = 5;
                    ctx.strokeStyle = "#4B2C20";
                    ctx.lineCap = "round";
                    ctx.beginPath();
                    ctx.moveTo(lastX, lastY);
                    ctx.lineTo(currentX, currentY);
                    ctx.stroke();
                }

                property int lastX: 0
                property int lastY: 0
                property int currentX: 0
                property int currentY: 0

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        drawingCanvas.lastX = mouse.x;
                        drawingCanvas.lastY = mouse.y;
                    }
                    onPositionChanged: {
                        drawingCanvas.currentX = mouse.x;
                        drawingCanvas.currentY = mouse.y;
                        drawingCanvas.requestPaint();
                        drawingCanvas.lastX = drawingCanvas.currentX;
                        drawingCanvas.lastY = drawingCanvas.currentY;
                    }
                }
            }

            // Top Right Speaker Icon
            Rectangle {
                id: speakerIcon
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 20
                width: 80
                height: 80
                radius: 40
                color: "white"
                border.color: accentColor
                border.width: 3

                Text {
                    anchors.centerIn: parent
                    text: "🔊"
                    font.pixelSize: 40
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Speaker Clicked - Play Sound")
                }
            }

            // Bottom Right Submit Button
            Button {
                id: submitButton
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 20
                width: 150
                height: 70

                background: Rectangle {
                    radius: 20
                    color: submitButton.pressed ? "#388E3C" : buttonColor
                    border.color: "white"
                    border.width: 4
                    layer.enabled: true
                }

                contentItem: Text {
                    text: "SUBMIT"
                    font.bold: true
                    font.pixelSize: 24
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: console.log("Submit Clicked!")
            }

            // Decorative Title on Canvas
            Text {
                anchors.centerIn: parent
                text: "My Creative Pad"
                font.pixelSize: 32
                font.family: "Comic Sans MS"
                color: "#8B4513"
                opacity: 0.3
            }
        }
    }
}
