import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property var model
    property bool isGridView: true
    signal infoClicked(string name, string description)

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 10
            
            Label {
                text: "View Mode:"
                font.bold: true
            }

            Button {
                text: "Grid"
                highlighted: isGridView
                onClicked: isGridView = true
            }

            Button {
                text: "List"
                highlighted: !isGridView
                onClicked: isGridView = false
            }
        }

        StackLayout {
            currentIndex: isGridView ? 0 : 1
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridView {
                id: gridView
                model: root.model
                cellWidth: 160
                cellHeight: 160
                delegate: ItemDelegate {
                    itemData: modelData
                    isGridView: true
                    onInfoClicked: root.infoClicked(name, description)
                }
            }

            ListView {
                id: listView
                model: root.model
                spacing: 5
                delegate: ItemDelegate {
                    itemData: modelData
                    isGridView: false
                    onInfoClicked: root.infoClicked(name, description)
                }
            }
        }
    }
}
