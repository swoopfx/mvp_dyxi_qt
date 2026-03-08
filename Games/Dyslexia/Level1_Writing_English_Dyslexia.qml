import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia


/**

  Defines a game targeting english speaking countrys
  Ages between 1-4 years ,
  has basic functionality
  letter recongnition, by comparison

  **/
Page{
  // anchors.fill: parent

    Component.onCompleted: {
        // start session;
        /// start Timer
        timer.startTimer();
    }


    // load pages hers
    Rectangle {
        anchors.fill: parent
        color: "#F4F9FF"

        RowLayout {
            anchors.fill: parent
            spacing: 20

            // ==============================
            // LEFT NAVIGATION PANEL
            // ==============================
            LeftNavigation{

                z:10


            }

            // ==============================
            // MAIN PLAYGROUND AREA
            // ==============================

            Playground{

            }

        }
    }


}
