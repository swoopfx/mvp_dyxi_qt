import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property var itemData
    property bool isGridView: true
    signal infoClicked(string name, string description)

    width: isGridView ? 150 : parent.width
    height: isGridView ? 150 : 60

    Rectangle {
        anchors.fill: parent
        anchors.margins: 5
        color: "#f0f0f0"
        border.color: "#ccc"
        radius: 5

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Text {
                text: itemData.name
                font.pixelSize: 16
                Layout.fillWidth: true
                elide: Text.ElideRight
                horizontalAlignment: isGridView ? Text.AlignHCenter : Text.AlignLeft
            }

            ToolButton {
                icon.name: "information"
                icon.source: "qrc:/qml/assets/info_icon.png" // Placeholder
                onClicked: root.infoClicked(itemData.name, itemData.description)
                
                // Fallback text if icon is missing
                Text {
                    anchors.centerIn: parent
                    text: "i"
                    visible: parent.icon.source === ""
                    font.bold: true
                }
            }
        }
    }
}
