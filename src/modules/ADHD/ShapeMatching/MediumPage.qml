import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: mediumPageRoot
    anchors.fill: parent

    // Medium difficulty (Ages 7-9) renders 5 shapes
    property double snapTolerance: 85.0

    Row {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 30

        Column {
            width: parent.width * 0.48
            height: parent.height
            spacing: 20
            anchors.verticalCenter: parent.verticalCenter

            ShapeItem {
                id: s1
                shapeType: "cube"; shapeName: "Magic Cube"; shapeGlyph: "🧊"; baseColor: "#EC4899"; gradientTo: "#BE185D"
                targetX: t1.x + socketCol.x; targetY: t1.y + socketCol.y; tolerance: mediumPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 80.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
            ShapeItem {
                id: s2
                shapeType: "sphere"; shapeName: "Sun Sphere"; shapeGlyph: "🟡"; baseColor: "#EAB308"; gradientTo: "#CA8A04"
                targetX: t2.x + socketCol.x; targetY: t2.y + socketCol.y; tolerance: mediumPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 80.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
            ShapeItem {
                id: s3
                shapeType: "pyramid"; shapeName: "Retro Pyramid"; shapeGlyph: "🔺"; baseColor: "#3B82F6"; gradientTo: "#1D4ED8"
                targetX: t3.x + socketCol.x; targetY: t3.y + socketCol.y; tolerance: mediumPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 80.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
            ShapeItem {
                id: s4
                shapeType: "cylinder"; shapeName: "Neon Cylinder"; shapeGlyph: "🟢"; baseColor: "#10B981"; gradientTo: "#047857"
                targetX: t4.x + socketCol.x; targetY: t4.y + socketCol.y; tolerance: mediumPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 80.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
            ShapeItem {
                id: s5
                shapeType: "star"; shapeName: "Gold Star"; shapeGlyph: "⭐"; baseColor: "#F97316"; gradientTo: "#D97706"
                targetX: t5.x + socketCol.x; targetY: t5.y + socketCol.y; tolerance: mediumPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 80.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
        }

        Column {
            id: socketCol
            width: parent.width * 0.48
            height: parent.height
            spacing: 20
            anchors.verticalCenter: parent.verticalCenter

            Rectangle { id: t1; width: 140; height: 80; radius: 12; color: "#10EC4899"; border.color: "#EC4899"; opacity: s1.isMatched ? 1.0 : 0.4; Text { anchors.centerIn: parent; text: "Place Cube"; color: "#EC4899" }}
            Rectangle { id: t2; width: 140; height: 80; radius: 12; color: "#10EAB308"; border.color: "#EAB308"; opacity: s2.isMatched ? 1.0 : 0.4; Text { anchors.centerIn: parent; text: "Place Sphere"; color: "#D6A307" }}
            Rectangle { id: t3; width: 140; height: 80; radius: 12; color: "#103B82F6"; border.color: "#3B82F6"; opacity: s3.isMatched ? 1.0 : 0.4; Text { anchors.centerIn: parent; text: "Place Pyramid"; color: "#3B82F6" }}
            Rectangle { id: t4; width: 140; height: 80; radius: 12; color: "#1010B981"; border.color: "#10B981"; opacity: s4.isMatched ? 1.0 : 0.4; Text { anchors.centerIn: parent; text: "Place Cylinder"; color: "#10B981" }}
            Rectangle { id: t5; width: 140; height: 80; radius: 12; color: "#10F97316"; border.color: "#F97316"; opacity: s5.isMatched ? 1.0 : 0.4; Text { anchors.centerIn: parent; text: "Place Star"; color: "#F97316" }}
        }
    }
}
