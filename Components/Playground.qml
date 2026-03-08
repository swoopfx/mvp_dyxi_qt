import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: playgroundArea
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "#FFFFFF"

    Image {
         id: bg_image
         source: "qrc:/img/images/playground.jpg"
         fillMode: Image.PreserveAspectCrop
         mipmap: true
         smooth: true
         anchors.fill: parent
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "🎮 Game Playground"
            font.pixelSize: 40
            font.bold: true
            color: "#333"
        }

        // Rectangle {
        //     width: 700
        //     height: 450
        //     radius: 20
        //     color: "#E3F2FD"
        //     border.color: "#90CAF9"
        //     border.width: 3

        //     Text {
        //         anchors.centerIn: parent
        //         text: "Game Content Appears Here"
        //         font.pixelSize: 24
        //         color: "#555"
        //     }
        // }
    }
}
