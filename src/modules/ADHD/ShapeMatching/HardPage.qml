import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: hardPageRoot
    anchors.fill: parent

    // Hard difficulty (Ages 10-13) renders 6 shapes with narrower tolerance & spatial drift animations
    property double snapTolerance: 70.0

    Row {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 20

        Column {
            width: parent.width * 0.48
            height: parent.height
            spacing: 12
            anchors.verticalCenter: parent.verticalCenter

            ShapeItem {
                id: s1; shapeType: "cube"; shapeName: "Magic Cube"; shapeGlyph: "🧊"; baseColor: "#EC4899"; gradientTo: "#BE185D"
                targetX: containerT1.x + socketCol.x; targetY: containerT1.y + socketCol.y + t1.y; tolerance: hardPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 60.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
            ShapeItem {
                id: s2; shapeType: "sphere"; shapeName: "Sun Sphere"; shapeGlyph: "🟡"; baseColor: "#EAB308"; gradientTo: "#CA8A04"
                targetX: containerT2.x + socketCol.x; targetY: containerT2.y + socketCol.y + t2.y; tolerance: hardPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 60.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
            ShapeItem {
                id: s3; shapeType: "pyramid"; shapeName: "Retro Pyramid"; shapeGlyph: "🔺"; baseColor: "#3B82F6"; gradientTo: "#1D4ED8"
                targetX: containerT3.x + socketCol.x; targetY: containerT3.y + socketCol.y + t3.y; tolerance: hardPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 60.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
            ShapeItem {
                id: s4; shapeType: "cylinder"; shapeName: "Neon Cylinder"; shapeGlyph: "🟢"; baseColor: "#10B981"; gradientTo: "#047857"
                targetX: containerT4.x + socketCol.x; targetY: containerT4.y + socketCol.y + t4.y; tolerance: hardPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 60.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
            ShapeItem {
                id: s5; shapeType: "star"; shapeName: "Gold Star"; shapeGlyph: "⭐"; baseColor: "#F97316"; gradientTo: "#D97706"
                targetX: containerT5.x + socketCol.x; targetY: containerT5.y + socketCol.y + t5.y; tolerance: hardPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 60.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
            ShapeItem {
                id: s6; shapeType: "torus"; shapeName: "Plasma Ring"; shapeGlyph: "🍩"; baseColor: "#A855F7"; gradientTo: "#7E22CE"
                targetX: containerT6.x + socketCol.x; targetY: containerT6.y + socketCol.y + t6.y; tolerance: hardPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 60.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
        }

        // Target outputs with elegant slow drift spatial challenges (Ages 10-13)
        Column {
            id: socketCol
            width: parent.width * 0.48
            height: parent.height
            spacing: 12
            anchors.verticalCenter: parent.verticalCenter

            Item {
                id: containerT1; width: 140; height: 68
                Rectangle {
                    id: t1; width: 140; height: 68; radius: 10; color: "#10EC4899"; border.color: "#EC4899"; opacity: s1.isMatched ? 1.0 : 0.4
                    Text { anchors.centerIn: parent; text: "Place Cube"; color: "#EC4899"; font.pixelSize: 10; font.bold: true }
                    
                    SequentialAnimation on y {
                        loops: Animation.Infinite
                        NumberAnimation { to: -8; duration: 1800; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: 8; duration: 1800; easing.type: Easing.InOutQuad }
                    }
                }
            }

            Item {
                id: containerT2; width: 140; height: 68
                Rectangle {
                    id: t2; width: 140; height: 68; radius: 10; color: "#10EAB308"; border.color: "#EAB308"; opacity: s2.isMatched ? 1.0 : 0.4
                    Text { anchors.centerIn: parent; text: "Place Sphere"; color: "#D6A307"; font.pixelSize: 10; font.bold: true }

                    SequentialAnimation on y {
                        loops: Animation.Infinite
                        NumberAnimation { to: 6; duration: 2150; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: -6; duration: 2150; easing.type: Easing.InOutQuad }
                    }
                }
            }

            Item {
                id: containerT3; width: 140; height: 68
                Rectangle {
                    id: t3; width: 140; height: 68; radius: 10; color: "#103B82F6"; border.color: "#3B82F6"; opacity: s3.isMatched ? 1.0 : 0.4
                    Text { anchors.centerIn: parent; text: "Place Pyramid"; color: "#3B82F6"; font.pixelSize: 10; font.bold: true }

                    SequentialAnimation on y {
                        loops: Animation.Infinite
                        NumberAnimation { to: -10; duration: 2500; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: 10; duration: 2500; easing.type: Easing.InOutQuad }
                    }
                }
            }

            Item {
                id: containerT4; width: 140; height: 68
                Rectangle {
                    id: t4; width: 140; height: 68; radius: 10; color: "#1010B981"; border.color: "#10B981"; opacity: s4.isMatched ? 1.0 : 0.4
                    Text { anchors.centerIn: parent; text: "Place Cylinder"; color: "#10B981"; font.pixelSize: 10; font.bold: true }

                    SequentialAnimation on y {
                        loops: Animation.Infinite
                        NumberAnimation { to: 8; duration: 1950; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: -8; duration: 1950; easing.type: Easing.InOutQuad }
                    }
                }
            }

            Item {
                id: containerT5; width: 140; height: 68
                Rectangle {
                    id: t5; width: 140; height: 68; radius: 10; color: "#10F97316"; border.color: "#F97316"; opacity: s5.isMatched ? 1.0 : 0.4
                    Text { anchors.centerIn: parent; text: "Place Star"; color: "#F97316"; font.pixelSize: 10; font.bold: true }

                    SequentialAnimation on y {
                        loops: Animation.Infinite
                        NumberAnimation { to: -6; duration: 2300; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: 6; duration: 2300; easing.type: Easing.InOutQuad }
                    }
                }
            }

            Item {
                id: containerT6; width: 140; height: 68
                Rectangle {
                    id: t6; width: 140; height: 68; radius: 10; color: "#10A855F7"; border.color: "#A855F7"; opacity: s6.isMatched ? 1.0 : 0.4
                    Text { anchors.centerIn: parent; text: "Place Ring"; color: "#7E22CE"; font.pixelSize: 10; font.bold: true }

                    SequentialAnimation on y {
                        loops: Animation.Infinite
                        NumberAnimation { to: 10; duration: 2600; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: -10; duration: 2600; easing.type: Easing.InOutQuad }
                    }
                }
            }
        }
    }
}
