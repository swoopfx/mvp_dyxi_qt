import QtQuick 2.15
import QtQuick.Controls

 Page {



     id: selectGamePage
     property string activeUserName: ""



     Image {
         id: bg_image
         source: "qrc:/img/images/Artboard.png"
         fillMode: Image.PreserveAspectCrop
         mipmap: true
         smooth: true
         anchors.fill: parent
     }

     Label{
         text: selectGamePage.activeUserName
         font.pixelSize: 28
         color: "black"
         horizontalAlignment: Text.AlignHCenter
         // Layout.alignment: Qt.AlignHCenter
     }
}
