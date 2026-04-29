import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: root
    visible: true
    width: 1024
    height: 768
    title: "Children's Learning Playground"

    property color selectedColor: "#FF5733"
    property int brushRadius: 10
    property var colors: ["#FF5733", "#33FF57", "#3357FF", "#F333FF"]

    // Telemetry integration
    TelemetryLogger {
        id: telemetry
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Menu Column (1/8th width)
        Rectangle {
            id: menuColumn
            Layout.preferredWidth: parent.width / 8
            Layout.fillHeight: true
            color: "#f0f0f0"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 20

                Text {
                    text: "Menu"
                    font.pixelSize: 24
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                // Color Palette
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10
                    Text { text: "Colors"; font.pixelSize: 18; Layout.alignment: Qt.AlignHCenter }
                    Repeater {
                        model: root.colors
                        Rectangle {
                            width: 50; height: 50
                            radius: 25
                            color: modelData
                            border.color: root.selectedColor === modelData ? "black" : "transparent"
                            border.width: 3

                            // Animation for button
                            scale: mouseArea.pressed ? 0.9 : 1.0
                            Behavior on scale { NumberAnimation { duration: 100 } }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                onClicked: root.selectedColor = modelData
                            }
                        }
                    }
                }

                // Brush Radius Control
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10
                    Text { text: "Brush Size"; font.pixelSize: 18; Layout.alignment: Qt.AlignHCenter }
                    Slider {
                        id: brushSlider
                        from: 2
                        to: 50
                        value: root.brushRadius
                        onValueChanged: root.brushRadius = value
                        Layout.fillWidth: true
                    }
                    Text { text: Math.round(brushSlider.value); font.pixelSize: 14; Layout.alignment: Qt.AlignHCenter }
                }

                Item { Layout.fillHeight: true } // Spacer

                // Submit Button
                Button {
                    text: "Submit"
                    Layout.fillWidth: true
                    onClicked: {
                        var finalData = telemetry.getFinalJson();
                        console.log("Telemetry Data Submitted:\n" + finalData);
                        // In a real app, you'd send this to a server or save to a file
                    }
                }
            }
        }

        // Right Canvas Column (7/8th width)
        Rectangle {
            id: canvasContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"

            Canvas {
                id: drawingCanvas
                anchors.fill: parent

                property var lastX: 0
                property var lastY: 0

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.lineWidth = root.brushRadius * 2;
                    ctx.lineCap = "round";
                    ctx.strokeStyle = root.selectedColor;
                    ctx.beginPath();
                    ctx.moveTo(lastX, lastY);
                    ctx.lineTo(mouseX, mouseY);
                    ctx.stroke();
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        drawingCanvas.lastX = mouseX;
                        drawingCanvas.lastY = mouseY;
                        telemetry.recordTouch(mouseX, mouseY, "pressed", root.selectedColor, root.brushRadius);
                    }
                    onPositionChanged: {
                        drawingCanvas.requestPaint();
                        telemetry.recordTouch(mouseX, mouseY, "moved", root.selectedColor, root.brushRadius);
                        drawingCanvas.lastX = mouseX;
                        drawingCanvas.lastY = mouseY;
                    }
                    onReleased: {
                        telemetry.recordTouch(mouseX, mouseY, "released", root.selectedColor, root.brushRadius);
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        telemetry.startSession();
    }
}
