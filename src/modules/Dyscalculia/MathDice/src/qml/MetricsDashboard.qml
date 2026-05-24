import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 300
    height: 400
    color: "#F0F0F0"
    radius: 20
    border.color: "#BDC3C7"
    border.width: 2

    property var metrics: ({})

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "Performance Metrics"
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        MetricRow { label: "Accuracy"; value: (metrics.accuracy * 100).toFixed(1) + "%"; color: "#27AE60" }
        MetricRow { label: "Concentration"; value: metrics.concentration.toFixed(1); color: "#2980B9" }
        MetricRow { label: "Frequency"; value: metrics.frequency.toFixed(2) + " /min"; color: "#8E44AD" }
        MetricRow { label: "Correct"; value: metrics.total_correct; color: "#2ECC71" }
        MetricRow { label: "Failed"; value: metrics.total_failed; color: "#E74C3C" }

        Item { Layout.fillHeight: true }

        Text {
            text: "Focus on consistency to improve concentration!"
            font.italic: true
            font.pixelSize: 12
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
