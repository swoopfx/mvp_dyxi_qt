import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: gameListPage

    property string pageTitle: ""
    required property var model
    property string avatar: ""
    property string  resoucesUrl: ""
    property string moduleName: ""

    Image {
        id: bg_image
        source: "qrc:/ui/images/kidi.jpg"
        fillMode: Image.PreserveAspectCrop
        mipmap: true
        smooth: true
        anchors.fill: parent
        opacity: 0.4
    }

    GridView {
        id: gridView
        anchors.fill: parent

        anchors.margins: 10
        cellWidth: parent.width / 3
        cellHeight: 200
        model: gameListPage.model
        delegate: Item {
            width: gridView.cellWidth
            height: gridView.cellHeight

            Rectangle {
                anchors.fill: parent
                anchors.margins: 10 // Cell padding/margin
                // color: "#FFD3AC"
              color: "#e0e0e0"
                radius: 12
                // border.color: "#333333"
                // border.color: "#ffffff"
                border.width: 4

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Main delegate clicked for item: " + String(modelData.gameName))
                        // You can add your main delegate click action here
                        stackView.push("qrc:/"+gameListPage.resoucesUrl+"/"+gameListPage.moduleName+"/"+modelData.games.gamePage+".qml")
                    }
                }


                  Rectangle {
                      anchors.fill: parent
                      anchors.margins: 4
                      color: "transparent"
                      border.width: 8
                      border.color: "#9e9e9e" // Inner shadow (top/left)
                  }

                // Main Layout
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    // Avatar Container
                    Rectangle {
                        width: 100
                        height: 100
                        radius: 50
                        color: "#2a2a2a"
                        clip: true
                        Layout.alignment: Qt.AlignTop

                        Image {
                            anchors.fill: parent
                            source: gameListPage.avatar
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                        }
                    }

                    // Text Content Container
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 4

                        Label {
                            text: modelData.games.gameName
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 18
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Label {
                            text: modelData.games.gameDefinition
                            color: "#aaaaaa"
                            font.pixelSize: 13
                            wrapMode: Text.Wrap
                            maximumLineCount: 4 // Prevents layout destruction by long text
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            verticalAlignment: Text.AlignTop
                        }
                    }
                }

                // --- DROPDOWN MENU (Top Right) ---
                ToolButton {
                    id: menuButton
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 8
                    width: 32
                    height: 32

                    contentItem: Text {
                        text: "⋮" // Vertical ellipsis
                        color: menuButton.hovered ? "#ffffff" : "#888888"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: menuButton.pressed ? "#444444" : (menuButton.hovered ? "#333333" : "transparent")
                        radius: 16
                    }

                    onClicked: contextMenu.open()

                    Menu {
                        id: contextMenu
                        y: menuButton.height

                        MenuItem {
                            text: "View Details"
                            onTriggered: console.log("Viewing: " + model.name)
                        }
                        MenuItem {
                            text: "Edit Character"
                            onTriggered: console.log("Editing: " + model.name)
                        }
                        MenuSeparator {}
                        MenuItem {
                            text: "Delete"
                            onTriggered: console.log("Deleting: " + model.name)
                        }
                    }
                }
            }
        }
        // spacing: 1 // Small spacing between delegates

        // ScrollIndicator.vertical: ScrollIndicator {
        //     id: verticalIndicator
        // }
    }

    Component.onCompleted: {
        // console.log(gameItemListPage.model[0].gameName)
    }
}
