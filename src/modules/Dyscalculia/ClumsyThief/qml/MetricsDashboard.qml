import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: dashboard
    width: 300
    height: 400
    color: "#CC000000"
    radius: 15
    border.color: "#FFD700"
    border.width: 2

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "Learning Metrics"
            font.pixelSize: 28
            font.bold: true
            color: "#FFD700"
            Layout.alignment: Qt.AlignHCenter
        }

        MetricRow { label: "Number Sense:"; value: gameEngine.metrics[0] }
        MetricRow { label: "Mental Math Speed:"; value: "2.4s" }
        MetricRow { label: "Accuracy:"; value: gameEngine.metrics[2].toFixed(1) + "%" }
        MetricRow { label: "Concentration:"; value: "High" }

        Item { Layout.fillHeight: true }

        Button {
            text: "Export JSON"
            Layout.fillWidth: true
            onClicked: gameEngine.exportMetrics()
        }
    }
}

// Internal component for rows
component MetricRow : RowLayout {
    property string label: ""
    property string value: ""
    Text { text: label; color: "white"; font.pixelSize: 18; Layout.fillWidth: true }
    Text { text: value; color: "#00FF00"; font.pixelSize: 18; font.bold: true }
}
