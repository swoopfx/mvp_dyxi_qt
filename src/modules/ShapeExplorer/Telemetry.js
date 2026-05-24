.pragma library

var gameData = {
    total_game_time: 0,
    start_time: 0,
    total_correct: 0,
    total_failed: 0,
    total_tries: 0,
    match_events: [],
    input_events: [],
    creative_index: 0,
    problem_solving_index: 0
};

var currentSelectionTime = 0;

function startGame() {
    gameData.start_time = Date.now();
}

function recordSelection() {
    currentSelectionTime = Date.now();
}

function recordMatch(shapeId, success, totalDuration) {
    var now = Date.now();
    var selectToMatch = now - currentSelectionTime;
    
    gameData.total_tries++;
    if (success) gameData.total_correct++;
    else gameData.total_failed++;
    
    gameData.match_events.push({
        shape_id: shapeId,
        status: success ? "correct" : "failed",
        select_to_match_duration: selectToMatch,
        total_duration: totalDuration,
        timestamp: now
    });
}

function recordInput(pressTime, duration, direction, rabbitVisible, rabbitVisibleDuration) {
    var ratio = rabbitVisible ? (duration / rabbitVisibleDuration) : 0;
    
    gameData.input_events.push({
        press_time: pressTime,
        press_duration: duration,
        motion_direction: direction,
        rabbit_visible_at_press: rabbitVisible,
        rabbit_visibility_duration: rabbitVisibleDuration,
        press_vs_visibility_ratio: ratio
    });
}

function calculateIndices() {
    var correctEvents = gameData.match_events.filter(e => e.status === "correct");
    var failedEvents = gameData.match_events.filter(e => e.status === "failed");
    
    var avgTimeCorrect = correctEvents.length > 0 ? (correctEvents.reduce((acc, e) => acc + e.select_to_match_duration, 0) / correctEvents.length) : 0;
    var avgTimeFailed = failedEvents.length > 0 ? (failedEvents.reduce((acc, e) => acc + e.select_to_match_duration, 0) / failedEvents.length) : 0;
    
    gameData.average_time_correct = avgTimeCorrect;
    gameData.average_time_failed = avgTimeFailed;

    // Creative Index: Diversity of motion directions + unique shape interaction order
    var directions = new Set(gameData.input_events.map(e => e.motion_direction));
    gameData.creative_index = gameData.input_events.length > 0 ? (directions.size / 4) * 10 : 0; // Scale to 10
    
    // Problem Solving Index: Accuracy * Speed Factor
    var accuracy = (gameData.total_tries > 0) ? (gameData.total_correct / gameData.total_tries) : 0;
    var speedFactor = avgTimeCorrect > 0 ? Math.min(10, 5000 / avgTimeCorrect) : 0;
    gameData.problem_solving_index = accuracy * speedFactor;
}

function getFinalJson() {
    gameData.total_game_time = Date.now() - gameData.start_time;
    calculateIndices();
    // return JSON.stringify(gameData, null, 4);
    return gameData;
}
