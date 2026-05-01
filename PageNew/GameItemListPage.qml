import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import mvpDyxi



Page{

    id: gameItemListPage

    required property var model



    Image {
         id: bg_image
         source: "qrc:/img/images/playground.jpg"
         fillMode: Image.PreserveAspectCrop
         mipmap: true
         smooth: true
         anchors.fill: parent
    }




    ListView {
        id: listView
        anchors.fill: parent
        model:gameItemListPage.model
        delegate: Delegate {}
        spacing: 1 // Small spacing between delegates

        ScrollIndicator.vertical: ScrollIndicator {
            id: verticalIndicator
        }
    }

    Component.onCompleted: {
        console.log(gameItemListPage.model[0].gameName)
    }

    // AllString{



}
