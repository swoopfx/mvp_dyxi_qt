import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import mvpDyxi  // Replace with your module name

Page {
    width: 800
    height: 600
    visible: true
    title: "Traceable Text Demo"

    Column {
        anchors.centerIn: parent
        spacing: 30

        // Example 1: CAT
        TracableTexte {
            id: catText
            width: 300
            height: 100
            text: "CAT"
            font.family: "Arial"
            font.pixelSize: 48
            font.bold: true
            outlineColor: "steelblue"
            traceColor: "red"
            penStyle: Qt.DotLine
            penWidth: 4.0
            tracingEnabled: true
        }

        // Example 2: DOG
        TracableTexte {
            id: dogText
            width: 300
            height: 100
            text: "DOG"
            font.family: "Times"
            font.pixelSize: 52
            font.bold: true
            outlineColor: "darkgreen"
            traceColor: "crimson"
            penStyle: Qt.DashDotLine
            penWidth: 5.0
            tracingEnabled: true
            traceSmoothness: 0.4
        }

        Row {
            spacing: 20
            Button {
                text: "Clear CAT"
                onClicked: catText.clearTrace()
            }
            Button {
                text: "Clear DOG"
                onClicked: dogText.clearTrace()
            }
            Button {
                text: "Next Word"
                onClicked: {
                    var words = ["BAT", "HAT", "MAT", "SAT", "FAT"];
                    catText.text = words[Math.floor(Math.random() * words.length)];
                }
            }
        }
    }
}