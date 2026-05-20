import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Layouts
import QtQuick.Dialogs
import General

Page {
 id: pageLoader
 property bool isLoaded: false
 property bool isReady: false
 // required property int itemId
 // required property string  url
 // required property string queryName

 Loader{
     id:loader
     anchors.fill: parent
     source:"../Components/LoadingPage.qml"
 }



 Component.onCompleted: {

 }

 MessageDialog{
     id:errorDialog
     title:"Error"
     buttons: MessageDialog.Ok
 }

 Connections{
      function onRequestFailed(stt){
          // console.log(stt);
          errorDialog.text = stt;
          errorDialog.open();
      }

 }
}
