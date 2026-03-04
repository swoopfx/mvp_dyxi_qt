import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtMultimedia
// import "Pages"
import "Buttons"

Page {
    id: test

    property int test_width: 1280
    property int test_height: 800

    // width: dashboard.board_width
    // height: dashboard.board_height

    // title: qsTr("Home")
    Image {
        id: bg_image
        source: "qrc:/img/images/Welcome Dyxi.png"
        fillMode: Image.PreserveAspectCrop
        mipmap: true
        smooth: true
        anchors.fill: parent
    }
    // Label {
    //     color: "#f91b02"
    //     text: Application.organization
    //     font.pointSize: 50
    //     font.bold: true
    //     styleColor: "#f95030"
    //     anchors.centerIn: parent
    // }

    PulseButton {
        buttonText: "ENTER"
        isBold: true
        // anchors.centerIn: parent
        anchors.top: parent.top
        anchors.topMargin: parent.height * (2/3)
        anchors.horizontalCenter: parent.horizontalCenter
        textFontSize: 40

        onButtonClicked: {

            console.log("Pulsing Button Clicked!")
            stackView.push(Qt.resolvedUrl("Pages/SelectionPage.qml"), {
                               "board_width": test.test_width,
                               "board_height": test.test_height
                           })
        }

    }

    // Button {
    //     text: "Go to Detail Page"
    //     anchors.centerIn: parent
    //     onClicked: {

    //         // Pass properties to the Dashboard when pushing
    //         // stackView.push({
    //         //                    // item:"qrc:/
    //         //     // item: Qt.resolvedUrl("Lib/Pages/Dashboard.qml") ,
    //         //                    item: Qt.resolvedUrl("Ano.qml"),
    //         //     properties: {
    //         //         "board_width": test.test_width, // The key must match the property name
    //         //         "board_height": test.test_height
    //         //     }
    //         // });
    //         stackView.push(Qt.resolvedUrl("Lib/Pages/Dashboard.qml"), {
    //                            "board_width": test.test_width,
    //                            "board_height"// The key must match the property name
    //                            : test.test_height
    //                        })
    //     }
    // }
}
