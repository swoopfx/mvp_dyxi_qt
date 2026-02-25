import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Layouts

Page {
    id:dashboard

    property int board_width: 600
    property int board_height: 400

    width: dashboard.board_width
    height: dashboard.board_height



    // title: qsTr("Home")
    Image {
        id: bg_image
        source: "qrc:/img/Artboard 1.png"
        fillMode: Image.Stretch
        anchors.fill: parent
    }

    // Rectangle{
    //     anchors.fill:  parent *0.15
    //     color: "#ccc"
    // }



    ColumnLayout{
        anchors.centerIn: parent
        spacing: 20
        width: parent.width *0.6

        Label{
            text: "Enter Student ID"
            font.pixelSize: 28
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        TextField{
            id: studentinput
            placeholderText: "Student ID"
            font.pixelSize: 38
            Layout.fillWidth: true
            height: 100


            background: Rectangle{
                radius: 10
                border.color: "#ffffff"
                border.width: 2
                color: "#fffffc"

            }
        }

        Button{
            text: "Submit"
            Layout.fillWidth: true
            font.pixelSize: 38
            height: 100
            visible: !service.isLoadingData
            background: Rectangle{
                radius: 10
                color: "#4CAF50"
            }

            onClicked:{
                console.log("Submit button clicked")
                service.helloworld();
                service.getStudentDetailsApiRequest("https://yahoo..com");
            }
        }
    }

    Rectangle{
        anchors.centerIn: parent
        id: opaqueIndicatorBg
        color: "#E0E0E0"




        BusyIndicator{
            id: indi
            anchors.centerIn: parent
            width: 100
            height: 100
            running: service.isLoadingData
            visible: running
            // contentItem: Item{
            //     opacity: indi.running ? 1 : 0
            // }

            // background: {
            //     color: "grey"
            //     opacity: 0.5
            // }
        }

    }



}
