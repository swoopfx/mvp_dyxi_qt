import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Page {



     id: selectGamePage
     property string activeUserName: ""
     // anchors.fill: parent



     Image {
          id: bg_image
          source: "qrc:/img/images/playground.jpg"
          fillMode: Image.PreserveAspectCrop
          mipmap: true
          smooth: true
          anchors.fill: parent
     }

     // Label{
     //     text: selectGamePage.activeUserName
     //     font.pixelSize: 28
     //     color: "black"
     //     horizontalAlignment: Text.AlignHCenter
     //     // Layout.alignment: Qt.AlignHCenter
     // }
     ColumnLayout{
          anchors.centerIn:  parent
          spacing : 20

          Row{
               // anchors.centerIn: parent
               // spacing: 20

               Label{
                    text: "Select A Category"
                    font.pixelSize: 28
                    color: "black"
                    // horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
               }
          }

          Row{
               // anchors.centerIn: parent
               spacing: 60

               ImageButton{
                    // source: "qrc:/img/images/ADHD_Symbol.png"
                    source: "qrc:/img/images/Dyslexia_Symbol.png"
                    onClicked: stackView.push("../Games/ADHD/NewGame2.qml")

               }

               ImageButton{

                     source: "qrc:/img/images/ADHD_Symbol.png"
                    onClicked: stackView.push("../Games/ADHD/Game1.qml")

               }

          }
     }
}
