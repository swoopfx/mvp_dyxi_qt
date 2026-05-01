import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import mvpDyxi

Page{
    id: pageDefaultPlaygroundLoader

    Loader {
        id: contentLoader
        anchors.fill: parent
        asynchronous: true
        source: "../Pages/LoadingPage.qml"


}

    Timer {
           id: loadTimer
           interval: 5000     // 2 seconds
           running: true      // Starts automatically
           repeat: false      // Only run once

           onTriggered: {
               console.log("Timer finished, loading component...")
               contentLoader.source = "../Pages/MainPlaygroundPage.qml"
           }
       }

       // Placeholder shown while waiting
       Text {
           visible: contentLoader.status !== Loader.Ready
           text: "Loading in 2 seconds..."
           anchors.centerIn: parent
       }

}
