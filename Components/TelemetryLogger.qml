import QtQuick 2.15

Item {
    id: telemetryRoot

    // Internal state
    property var sessionData: []
    property double startTime: 0
    property var lastTouch: null
    property double continuousTouchStartTime: 0
    property bool isTouching: false

    function startSession() {
        startTime = new Date().getTime();
        sessionData = [];
        console.log("Telemetry session started at: " + startTime);
    }

    function recordTouch(x, y, type, color, radius) {
        var currentTime = new Date().getTime();
        var timeFromStart = currentTime - startTime;

        var touchEvent = {
            "timestamp": timeFromStart,
            "type": type,
            "position": { "x": x, "y": y },
            "telemetric_data": {
                "color": color,
                "brush_radius": radius
            }
        };

        // Handle continuous touch timing
        if (type === "pressed") {
            isTouching = true;
            continuousTouchStartTime = currentTime;
            touchEvent["continuous_touch_duration"] = 0;
        } else if (type === "moved" && isTouching) {
            touchEvent["continuous_touch_duration"] = currentTime - continuousTouchStartTime;
        } else if (type === "released") {
            touchEvent["continuous_touch_duration"] = currentTime - continuousTouchStartTime;
            isTouching = false;
        }

        // Calculate distance and direction if there was a previous touch
        if (lastTouch) {
            var dx = x - lastTouch.position.x;
            var dy = y - lastTouch.position.y;
            var distance = Math.sqrt(dx * dx + dy * dy);
            var angleLinear = Math.atan2(dy, dx) * (180 / Math.PI); // Linear direction in degrees

            touchEvent["distance_from_last"] = distance;
            touchEvent["direction_linear"] = angleLinear;
            touchEvent["time_since_last"] = timeFromStart - lastTouch.timestamp;

            // Angular direction (change in direction)
            if (lastTouch.direction_linear !== undefined) {
                var angleChange = angleLinear - lastTouch.direction_linear;
                // Normalize angle change to [-180, 180]
                while (angleChange > 180) angleChange -= 360;
                while (angleChange < -180) angleChange += 360;
                touchEvent["direction_angular"] = angleChange;
            } else {
                touchEvent["direction_angular"] = 0;
            }
        } else {
            touchEvent["distance_from_last"] = 0;
            touchEvent["direction_linear"] = 0;
            touchEvent["direction_angular"] = 0;
            touchEvent["time_since_last"] = 0;
        }

        sessionData.push(touchEvent);
        lastTouch = touchEvent;
    }

    function getFinalJson() {
        var endTime = new Date().getTime();
        var totalDuration = endTime - startTime;

        var finalObject = {
            "session_summary": {
                "start_time_epoch": startTime,
                "end_time_epoch": endTime,
                "total_duration_ms": totalDuration,
                "total_events": sessionData.length
            },
            "events": sessionData
        };

        return JSON.stringify(finalObject, null, 4);
    }
}
