import QtQuick
import QtQuick.Controls
import QtQuick.Window
// import TraceableText 1.0

import mvpDyxi

Item {
    id: window
  anchors.fill: parent
    // color: "#f0f0f0"

    Column {
        spacing: 20
        anchors.centerIn: parent

        TraceableText {
            id: traceText
            width: 300
            height: 120
            text: "cat"
            font.family: "Arial"
            font.pointSize: 48
            penColor: "blue"
            penStyle: Qt.DotLine
            penWidth: 4
            traceColor: "red"

            // Ensure mouse events are propagated
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed: traceText.mousePressEvent(mouse)
                onPositionChanged: traceText.mouseMoveEvent(mouse)
                onReleased: traceText.mouseReleaseEvent(mouse)
            }
        }

        Row {
            spacing: 10

            Button {
                text: "Reset"
                // onClicked: traceText.m_tracePath = QPainterPath(); traceText.update()
            }

            Button {
                text: "Dotted"
                onClicked: traceText.penStyle = Qt.DotLine
            }
            Button {
                text: "Dashed"
                onClicked: traceText.penStyle = Qt.DashLine
            }

            Slider {
                id: widthSlider
                from: 1.0
                to: 10.0
                stepSize: 0.5
                value: 4.0
                onValueChanged: traceText.penWidth = value
            }
        }
    }
}