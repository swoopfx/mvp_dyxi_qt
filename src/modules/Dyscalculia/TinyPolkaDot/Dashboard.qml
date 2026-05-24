import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#F0F8FF"
    property var engine

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 20

        Text {
            text: "Session Performance Dashboard"
            font.pixelSize: 32
            font.bold: true
            color: "#4682B4"
            Layout.alignment: Qt.AlignHCenter
        }

        GridLayout {
            columns: 2
            rowSpacing: 20
            columnSpacing: 40
            Layout.alignment: Qt.AlignHCenter

            MetricBox { label: "Total Score"; value: engine.score; color: "#FF69B4" }
            MetricBox { label: "Accuracy"; value: engine.accuracy.toFixed(1) + "%"; color: "#32CD32" }
            MetricBox { label: "Avg Speed"; value: engine.avgSpeed.toFixed(2) + "s"; color: "#1E90FF" }
            MetricBox { label: "Concentration"; value: engine.concentrationScore.toFixed(1); color: "#FFA500" }
            MetricBox { label: "Correct"; value: engine.correctCount; color: "#228B22" }
            MetricBox { label: "Failed"; value: engine.failCount; color: "#FF4500" }
        }

        Button {
            text: "Back to Game"
            Layout.alignment: Qt.AlignHCenter
            onClicked: root.visible = false
        }
    }
}
