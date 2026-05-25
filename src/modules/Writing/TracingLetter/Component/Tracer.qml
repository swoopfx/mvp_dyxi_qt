import QtQuick 2.15
import QtQuick.Controls

Item {
    id: tracer

    anchors.centerIn: parent
    property string letter: "A"
    property int size: 100

    // Reusable Traceable Letter Component
    Text {
        anchors.centerIn: parent
        text: tracer.letter
        font.family: "Arial" // Use a clean, sans-serif font
        font.pixelSize: tracer.size
        font.bold: true

        // Core properties to generate the outline effect
        style: Text.Outline
        styleColor: "gray" // The color of the dotted outline
        color: "transparent" // Hides the solid fill so only the outline is visible

        // Generates the dotted/dashed effect
        renderType: Text.NativeRendering
        font.hintingPreference: Font.PreferNoHinting

        // Note: Native QML Text elements do not support "dotted/dashed"
        // stroke styles directly. To achieve precise dots or dashes,
        // it is highly recommended to pair this with a custom traceable font
        // (e.g., "KG Primary Dots" or "Trace Font") loaded in your system.
    }

    // Row {
    //     spacing: 20
    //     TraceableLetter {
    //         letter: "Ant"
    //     }
    //     TraceableLetter {
    //         letter: "B"
    //     }
    //     TraceableLetter {
    //         letter: "C"
    //     }
    // }
}
