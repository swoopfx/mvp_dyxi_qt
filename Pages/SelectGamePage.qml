import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "../Buttons"
import "../Components"

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


     Column {
         anchors.fill: parent
         anchors.margins: 40
         spacing: 40

         // Header
         Rectangle {
             width: parent.width
             height: 120
             color: "white"
             radius: 60
             border.color: "#AED581"
             border.width: 5

             Text {
                 anchors.centerIn: parent
                 text: "My Learning World"
                 color: "#558B2F"
                 font.family: "Verdana", "Arial"
                 font.pixelSize: 42
                 font.bold: true
                 // letterSpacing: 2
             }
         }

         // The Grid of Distinct Items
         Flow {
             id: grid
             width: parent.width
             spacing: 30
             anchors.horizontalCenter: parent.horizontalCenter
             flow: Flow.LeftToRight

             GameItem {
                 labelText: "Phonics Fun"
                 imageSource: "qrc:/img/images/phonics.jpg"
                 accentColor: "#FF8A65"
                   onClicked: stackView.push("RobotPage.qml")
             }

             GameItem {
                 labelText: "Word Tracing"
                 imageSource: "qrc:/img/images/tracing.webp"
                 accentColor: "#4DB6AC"
                 onClicked: stackView.push("ABC123.qml")
             }

             GameItem {
                 labelText: "Recognition"
                 imageSource: "qrc:/img/images/recognition.png"
                 accentColor: "#9575CD"
                 onClicked: stackView.push("../Games/ADHD/NewGame2.qml")
             }

             GameItem {
                 labelText: "Reading Time"
                 imageSource: "qrc:img/images/reading.png"
                 accentColor: "#F06292"
             }

             GameItem {
                 labelText: "Writing Practice"
                 imageSource: "qrc:/img/images/writing.png"
                 accentColor: "#FFD54F"
             }
         }

         // Interactive Footer
         Rectangle {
             width: parent.width * 0.7
             height: 80
             anchors.horizontalCenter: parent.horizontalCenter
             color: "#FFFFFF"
             radius: 40
             border.color: "#C5E1A5"
             border.width: 3

             Text {
                 anchors.centerIn: parent
                 text: "Pick an activity to start your adventure!"
                 color: "#7CB342"
                 font.family: "Verdana"
                 font.pixelSize: 24
                 font.bold: true
             }
         }
     }

     // Label{
     //     text: selectGamePage.activeUserName
     //     font.pixelSize: 28
     //     color: "black"
     //     horizontalAlignment: Text.AlignHCenter
     //     // Layout.alignment: Qt.AlignHCenter
     // }
     // ColumnLayout{
     //      id: cLay
     //      anchors.centerIn:  parent
     //      spacing : 20


     //      Row{
     //                // anchors.centerIn: parent
     //                spacing: 60
     //                Rectangle{
     //                     // anchors.fill: parent
     //                     width:400
     //                     height:400
     //                     color: "transparent"
     //                     border.color: "black"
     //                     radius: 10

     //                     ImageButton{
     //                          id: dyslexia
     //                          // source: "qrc:/img/images/ADHD_Symbol.png"
     //                          source: "qrc:/img/images/Dyslexia_Symbol.png"
     //                          onClicked: stackView.push("../Games/ADHD/NewGame2.qml")
     //                           anchors.horizontalCenter: parent.horizontalCenter

     //                     }

     //                     Text {
     //                          text: "DYSLEXIA"
     //                          font.pixelSize: 32
     //                          font.bold: true
     //                          anchors.top: dyslexia.bottom
     //                          anchors.horizontalCenter: parent.horizontalCenter
     //                          // anchors.top: parent.top
     //                          // anchors.topMargin: 20
     //                     }
     //                }

     //                Rectangle{
     //                     width:400
     //                     height:400
     //                     color: "transparent"
     //                     border.color: "black"
     //                     radius: 10



     //                     ImageButton{
     //                          id: adhd
     //                          source: "qrc:/img/images/ADHD_Symbol.png"
     //                          onClicked: stackView.push("../Games/Dyslexia/GameTest.qml", {levelId: 1})
     //                           anchors.horizontalCenter: parent.horizontalCenter


     //                     }

     //                     Text {
     //                          text: "ADHD"
     //                          font.pixelSize: 32
     //                          font.bold: true
     //                          anchors.top: adhd.bottom
     //                          anchors.horizontalCenter: parent.horizontalCenter
     //                          // anchors.top: parent.top
     //                          // anchors.topMargin: 20
     //                     }
     //                }

     //           }


     // }


}
