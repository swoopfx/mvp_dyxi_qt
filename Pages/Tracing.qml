import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import AdhdModule

// import

Page {
    width: 640
    height: 480
    visible: true
    title: qsTr("3-Letter Word Tracing")

    property var wordList: ["CAT", "DOG", "SUN", "BAT", "HAT", "CUP", "BOX", "FLY", "RUN", "PEN"]
    property int currentWordIndex: 0

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"

        // Main Tracable Text Item
        TracableText {
            id: tracableTextItem
            anchors.centerIn: parent
            width: parent.width * 0.9
            height: parent.height * 0.5
            text: wordList[currentWordIndex]
            font.family: "Arial"
            font.pixelSize: 150
            font.bold: true
            penColor: "#444444"
            penStyle: Qt.DotLine
            penWidth: 3
            traceColor: "red" // Default trace color

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    tracableTextItem.startNewTracePath(mouse.x, mouse.y)
                }
                onPositionChanged: {
                    if (mouse.pressed) {
                        tracableTextItem.addTracePoint(mouse.x, mouse.y)
                    }
                }
                onReleased: {
                    // Optionally finalize the path or do nothing
                }
            }
        }

        // Navigation Controls
        Row {
            anchors.bottom: settingsPanel.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
            spacing: 30

            Button {
                text: "Previous"
                enabled: currentWordIndex > 0
                onClicked: {
                    currentWordIndex--
                    tracableTextItem.clearTrace() // Clear trace when word changes
                }
            }

            Text {
                text: (currentWordIndex + 1) + " / " + wordList.length
                font.pixelSize: 18
                anchors.verticalCenter: parent.verticalCenter
            }

            Button {
                text: "Next"
                enabled: currentWordIndex < wordList.length - 1
                onClicked: {
                    currentWordIndex++
                    tracableTextItem.clearTrace() // Clear trace when word changes
                }
            }
        }

        // Settings Panel
        Rectangle {
            id: settingsPanel
            anchors.bottom: parent.bottom
            width: parent.width
            height: 100
            color: "#f8f8f8"
            border.color: "#dddddd"

            Row {
                anchors.centerIn: parent
                spacing: 20

                Column {
                    spacing: 5
                    Label { text: "Outline Style:" }
                    ComboBox {
                        model: ["Solid", "Dashed", "Dotted"]
                        currentIndex: 2
                        onCurrentIndexChanged: {
                            if (currentIndex == 0) tracableTextItem.penStyle = Qt.SolidLine;
                            else if (currentIndex == 1) tracableTextItem.penStyle = Qt.DashLine;
                            else tracableTextItem.penStyle = Qt.DotLine;
                        }
                    }
                }

                Column {
                    spacing: 5
                    Label { text: "Line Thickness:" }
                    Slider {
                        id: widthSlider
                        from: 1
                        to: 10
                        value: 3
                        onValueChanged: tracableTextItem.penWidth = value
                    }
                }

                Column {
                    spacing: 5
                    Label { text: "Outline Color:" }
                    Row {
                        spacing: 5
                        Repeater {
                            model: ["#444444", "#ff0000", "#0000ff", "#008800"]
                            delegate: Rectangle {
                                width: 30; height: 30
                                color: modelData
                                border.width: tracableTextItem.penColor == modelData ? 2 : 0
                                border.color: "black"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: tracableTextItem.penColor = modelData
                                }
                            }
                        }
                    }
                }

                Column {
                    spacing: 5
                    Label { text: "Trace Color:" }
                    Row {
                        spacing: 5
                        Repeater {
                            model: ["red", "blue"]
                            delegate: Rectangle {
                                width: 30; height: 30
                                color: modelData
                                border.width: tracableTextItem.traceColor == modelData ? 2 : 0
                                border.color: "black"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: tracableTextItem.traceColor = modelData
                                }
                            }
                        }
                    }
                }

                Button {
                    text: "Clear Trace"
                    onClicked: tracableTextItem.clearTrace()
                }
            }
        }
    }
}
