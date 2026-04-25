import QtQuick

Item {
    id: tracker

    property var sessionData: []
    property var currentDragData: null
    property double lastMoveTime: 0

    function recordDragStart(color) {
        currentDragData = {
            color: color,
            startTime: Date.now(),
            path: [],
            jitter: 0,
            success: false
        };
        lastMoveTime = Date.now();
    }

    function recordMovement(px, py) {
        if (currentDragData) {
            let now = Date.now();
            currentDragData.path.push({x: px, y: py, t: now});
            
            // Simple jitter calculation
            if (currentDragData.path.length > 2) {
                let p1 = currentDragData.path[currentDragData.path.length - 2];
                let p2 = currentDragData.path[currentDragData.path.length - 1];
                let dist = Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2));
                currentDragData.jitter += dist;
            }
            lastMoveTime = now;
        }
    }

    function recordDrop(success, color, dropX, dropY) {
        if (currentDragData) {
            currentDragData.success = success;
            currentDragData.endTime = Date.now();
            currentDragData.dropX = dropX;
            currentDragData.dropY = dropY;
            
            // Calculate Path Efficiency
            let start = currentDragData.path[0];
            let end = currentDragData.path[currentDragData.path.length - 1];
            let straightDist = Math.sqrt(Math.pow(end.x - start.x, 2) + Math.pow(end.y - start.y, 2));
            currentDragData.pathEfficiency = straightDist / currentDragData.jitter;
            
            sessionData.push(currentDragData);
            currentDragData = null;
        }
    }

    function exportData() {
        let jsonStr = JSON.stringify(sessionData, null, 2);
        console.log("JSON Metrics:\n" + jsonStr);
        
        let csvStr = "Trial,Color,Success,StartTime,Duration,PathEfficiency,Jitter\n";
        sessionData.forEach((trial, index) => {
            csvStr += `${index + 1},${trial.color},${trial.success},${trial.startTime},${trial.endTime - trial.startTime},${trial.pathEfficiency.toFixed(4)},${trial.jitter.toFixed(2)}\n`;
        });
        console.log("CSV Metrics:\n" + csvStr);
        
        // In a real Qt environment, we would use QFile to save these to the disk.
        // Since we are in a sandbox, we'll provide the data in the final response.
    }
}
