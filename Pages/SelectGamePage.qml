import QtQuick 2.15
import QtQuick.Controls
import Qt.QtCore

 Page {



     id: selectGamePage

     Settings{
         id:userSettings
     }

     Image {
         id: bg_image
         source: "qrc:/img/images/Artboard.png"
         fillMode: Image.PreserveAspectCrop
         mipmap: true
         smooth: true
         anchors.fill: parent
     }

     Label{
         text: userSettings.activeUserName
         font.pixelSize: 28
         color: "black"
         horizontalAlignment: Text.AlignHCenter
         // Layout.alignment: Qt.AlignHCenter
     }
}
