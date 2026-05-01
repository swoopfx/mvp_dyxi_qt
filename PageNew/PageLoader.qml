import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Layouts
import QtQuick.Dialogs

import mvpDyxi

Page{

    id: pageLoader


    ItemGameTypeConnection{
        id: itemConnection
    }

    // Condition variable
    property bool isLoaded: false
    property bool isReady: false
    property string dataToPass: "Hello World"
    // property var modelData: ""
    required property int itemId
    required property string  url
    required property string queryName
    property string createdUrl: pageLoader.url+"?"+pageLoader.queryName+"="+pageLoader.itemId

    // Simulate loading completion after 3 seconds
    // Timer {
    //     interval:5000; running: true; repeat: false
    //     onTriggered: isLoaded = true
    // }

    // Loader component to switch between views
    Loader {
        id: loader
        anchors.fill: parent
        // If false, load LoadingPage.qml, else load MainPage.qml
        source: "../Pages/LoadingPage.qml"




    // 3. Components
     // Component {
     //     id: loadingPage
     //    LoadingnPage{}
     // }

     // Component {
     //     id: mainPage
     //     GameItemListPage{
     //     }
     // }



         // function onItemGameTypeChanged(){

         // }


     }
    Component.onCompleted: {
        // function getItemList(){

        // }
        console.log("Starte Api Call")
        itemConnection.itemGameTypeApiRequest(pageLoader.createdUrl)

}

     MessageDialog{
         id:errorDialog
         title:"Error"
         buttons: MessageDialog.Ok
     }

     Connections{
         target:itemConnection

         function onItemGameTypeChanged(){
             // console.log("Item Changed");
             // console.log(itemConnection.isLoadedData);
             // console.log(JSON.stringify(itemConnection.itemGameType));
             // console.log(JSON.stringify(itemConnection.itemGameType[0].gameName));
              console.log(itemConnection.itemGameType[0].createdAt.date);
             // if(itemConnection.isLoadedData){
                 // pageLoader.modelData = itemConnection.itemGameType
                 // console.log("Data Chaneg");
                 pageLoader.isLoaded = true
                 loader.setSource("GameItemListPage.qml", { "model": itemConnection.itemGameType });
             // }
         }
         function onRequestFailed(stt){
             // console.log(stt);
             errorDialog.text = stt;
             errorDialog.open();
         }
     }






}
