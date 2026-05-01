import QtQuick
import QtQuick.Controls
import QtQuick.Window
import "Buttons"
import "Pages"
import mvpDyxi
import DyslexiaModule as Dyslexia
import Adhd.AdhdModule as Adhd




// Item {
//     id: main_root
//     width: 640
//     height: 480
//     visible: true
    // title: qsTr("Hello World")

    Window {
        id: main_window
        visible: true
        // width: 640
        // height: 480
        // title: qsTr("Stack")
        visibility: Window.Maximized



        // MMM{}
        // ANO{}
        Dyslexia.TT{}
        Adhd.APA{}


        property int screen_maximumHeight: 600
        property int screen_maximumWidth: 1280
        // readonly property real aspectRatio: 4.0/3.0

        // maximumHeight: Screen.desktopAvailaleHeight
        // maximumWidth: Screen.desktopAvailaleWidth

        minimumHeight: main_window.screen_maximumHeight
        minimumWidth: main_window.screen_maximumWidth

        // visibility: "FullScreen"


        // onWidthChanged: {
        //     if(visibility === Window.Windowed){
        //         height = width / aspectRatio
        //     }
        // }

        // onHeightChanged: {
        //     if(visibility === Window.Windowed){
        //         width = height * aspectRatio
        //     }
        // }


        // Image {
        //     id: bg_image
        //     source: "qrc:/img/Welcome.png"
        //     fillMode: Image.Stretch
        //     anchors.fill: parent
        // }

        Rectangle{
                id: errorScreen
                anchors.fill: parent
                color:"red"
                visible: false
                z:1000
                Text{
                        anchors.centerIn: parent
                        text:"Screen size too small"
                        color:"white"
                        font.pixelSize:30
                }
        }

        Component.onCompleted: {
                console.log(Screen.width);
                if(Screen.width < screen_maximumWidth || Screen.height < screen_maximumHeight){
                        errorScreen.visible = true;
                console.log(Screen.width);
                        console.log(Screen.height);
                        console.log(screen_maximumHeight);
                        console.log(screen_maximumWidth);


                }
        }

        StackView {
            id: stackView
            initialItem: "Basee.qml"
            anchors.fill: parent
            // Component{
                // id: initialPage
                // Page {
                //       id: mainPage
                //       title: "Main Page"

                //       Button {
                //           text: "Go to Detail Page"
                //           anchors.centerIn: parent
                //           onClicked: {
                //               // Pass properties to the Dashboard when pushing
                //               stackView.push({
                //                                  // item:Dashboard
                //                   item: "Lib/Pages/Dashboard.qml",

                //                   properties: {
                //                       "board_width": main_window.minimumWidth, // The key must match the property name
                //                       "board_height": main_window.minimumHeight
                //                   }
                //               });
                //           }
                //       }
                //   }

            // }
        }



    }


   // Rect


// }
