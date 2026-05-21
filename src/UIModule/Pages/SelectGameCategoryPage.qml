import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "../Components"
import General

Page {



     id: selectGamePage
     property string activeUserName: ""
     property string userAge: ""
     // anchors.fill: parent


     CoreSettings{
          id: coreSettings
     }

     Image {
          id: bg_image
          source: "qrc:/ui/images/playground.jpg"
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
             height: 60
             color: "white"
             radius: 60
             border.color: "#AED581"
             border.width: 5

             Text {
                 anchors.centerIn: parent
                 text: "Dyxi Learning World"
                 color: "#558B2F"
                 font.family: "Verdana", "Arial"
                 font.pixelSize: 12
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
                 imageSource: "qrc:/ui/images/phonics.png"
                 accentColor: "#FF8A65"
                   onClicked: stackView.push("GameLoaderPage.qml", {
                                                  // "url": coreSettings.baseUrl+"/api/game-by-type"+"?type=1"+"age"+UserSession.userAge,
                                                  "url":"https://mvp.dyxi.site/api/game-types"+"?type=1",
                                                  "pageTitle":"Phonics",
                                                  "avatar":"qrc:/ui/images/phonics.png"

                                             })
             }

             GameItem {
                 labelText: "Word Tracing"
                 imageSource: "qrc:/ui/images/tracing.png"
                 accentColor: "#4DB6AC"
                 onClicked: stackView.push("ABC123.qml")
             }

             GameItem {
                 labelText: "Recognition"
                 imageSource: "qrc:/ui/images/recognition.png"
                 accentColor: "#9575CD"
                 onClicked: stackView.push("Tracing.qml")
             }

             GameItem {
                 labelText: "Reading Time"
                 imageSource: "qrc:/ui/images/reading.png"
                 accentColor: "#F06292"
                 onClicked: stackView.push("Tracing.qml")
             }

             GameItem {
                 labelText: "Writing Practice"
                 imageSource: "qrc:/ui/images/writing.png"
                 accentColor: "#FFD54F"
                  onClicked: stackView.push("MainPlaygroundPage.qml")
             }
         }
         Component.onCompleted: {
              // get userSession
              // selectGamePage.userAge =
         }

         // Interactive Footer
         // Rectangle {
         //     width: parent.width * 0.7
         //     height:
         //     anchors.horizontalCenter: parent.horizontalCenter
         //     color: "#FFFFFF"
         //     radius: 40
         //     border.color: "#C5E1A5"
         //     border.width: 3

         //     Text {
         //         anchors.centerIn: parent
         //         text: "Pick an activity to start your adventure!"
         //         color: "#7CB342"
         //         font.family: "Verdana"
         //         font.pixelSize: 24
         //         font.bold: true
         //     }
         // }
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
