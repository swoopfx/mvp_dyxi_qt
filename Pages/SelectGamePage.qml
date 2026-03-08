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
          id: cLay
          anchors.centerIn:  parent
          spacing : 20


          Row{
                    // anchors.centerIn: parent
                    spacing: 60
                    Rectangle{
                         // anchors.fill: parent
                         width:400
                         height:400
                         color: "transparent"
                         border.color: "black"
                         radius: 10

                         ImageButton{
                              id: dyslexia
                              // source: "qrc:/img/images/ADHD_Symbol.png"
                              source: "qrc:/img/images/Dyslexia_Symbol.png"
                              onClicked: stackView.push("../Games/ADHD/NewGame2.qml")
                               anchors.horizontalCenter: parent.horizontalCenter

                         }

                         Text {
                              text: "DYSLEXIA"
                              font.pixelSize: 32
                              font.bold: true
                              anchors.top: dyslexia.bottom
                              anchors.horizontalCenter: parent.horizontalCenter
                              // anchors.top: parent.top
                              // anchors.topMargin: 20
                         }
                    }

                    Rectangle{
                         width:400
                         height:400
                         color: "transparent"
                         border.color: "black"
                         radius: 10


                         ImageButton{
                              id: adhd
                              source: "qrc:/img/images/ADHD_Symbol.png"
                              onClicked: stackView.push("../Games/Dyslexia/Level1_Tracing_English_Dyslexia.qml")
                               anchors.horizontalCenter: parent.horizontalCenter

                         }

                         Text {
                              text: "ADHD"
                              font.pixelSize: 32
                              font.bold: true
                              anchors.top: adhd.bottom
                              anchors.horizontalCenter: parent.horizontalCenter
                              // anchors.top: parent.top
                              // anchors.topMargin: 20
                         }
                    }

               }


     }
}
