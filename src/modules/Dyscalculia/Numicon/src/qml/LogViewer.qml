import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: logWindow
    width: 600
    height: 800
    title: "Activity Log (JSON)"
    visible: false

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            Text {
                text: "Session Activity Log"
                font.pixelSize: 24
                font.bold: true
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                TextArea {
                    id: logText
                    text: activityLogger.getLogsAsJsonString()
                    readOnly: true
                    font.family: "Monospace"
                    font.pixelSize: 12
                    wrapMode: TextArea.Wrap
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                Button {
                    text: "Refresh"
                    onClicked: logText.text = activityLogger.getLogsAsJsonString()
                }
                Button {
                    text: "Clear Logs"
                    onClicked: activityLogger.clearLogs()
                }
                Button {
                    text: "Close"
                    onClicked: logWindow.close()
                }
            }
        }
    }
}
