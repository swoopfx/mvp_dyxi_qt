import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Layouts
import "../Components"

Item {

   id: itemGameType

    SwitchableItemView {
        anchors.fill: parent
        model: itemManager.items
        onInfoClicked: (name, description) => {
            infoPopup.itemName = name;
            infoPopup.itemDescription = description;
            infoPopup.open();
        }
    }

    InfoPopup {
        id: infoPopup
    }

    Rectangle{
        anchors.centerIn: parent
        id: opaqueIndicator
         color: "#E0E0E0"

         BusyIndicator{
             id: busyindicator
             anchors.centerIn: parent
             running: itemGameTypeConnection.isLoading
             visible: running
         }
    }

    Component.onCompleted: {
        itemGameTypeConnection.itemGameTypeApiRequest("https://mvp.dyxi.site/application/get-student-details")

    }

    Connections{
        target: itemGameTypeConnection

        function onItemGameTypeChange(){

            // load model
            //display model


        }
    }

}
