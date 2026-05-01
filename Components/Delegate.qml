
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: delegateRoot
    width: parent.width
    height: 80

    property color oddColor: "#f0f0f0"
    property color evenColor: "#ffffff"


    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: index % 2 === 0 ? delegateRoot.evenColor : delegateRoot.oddColor

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Main delegate clicked for item: " + String(modelData.gameName))
                // You can add your main delegate click action here
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: 15
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            Image {
                id: avatar
                source: "qrc:/img/images/logo.png" // Role from C++ model
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                fillMode: Image.PreserveAspectFit
                sourceSize.width: 60
                sourceSize.height: 60
            }

            Label {
                id: labelTextItem
                text: modelData.gameName // Role from C++ model
                font.pixelSize: 18
                Layout.fillWidth: true
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            Image {
                id: infoIcon
                source: "qrc:/img/images/robot_limb.svg" // Placeholder for info icon
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                fillMode: Image.PreserveAspectFit
                sourceSize.width: 30
                sourceSize.height: 30

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Stop propagation to prevent the main delegate's MouseArea from also being triggered
                        mouse.accepted = true
                        infoModal.infoText = modelData.gameDefinition // Explicitly use model role
                        infoModal.open()
                    }
                }
            }
        }
    }

    InfoModal {
        id: infoModal
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
    }

}
