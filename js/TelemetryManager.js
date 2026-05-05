var sessionData = {
    total_time_up: 0,
    total_whacks: 0,
    successful_hits: 0,
    missed_whacks: 0,
    appearances: [],
    startTime: 0,
    lastWhackTime: 0,
    totalWhackIntervals: 0,
    whackIntervalCount: 0,
    total_click_duration: 0,
    total_visibility_duration: 0
};

function startGame() {
    sessionData.startTime = Date.now();
    sessionData.total_time_up = 0;
    sessionData.total_whacks = 0;
    sessionData.successful_hits = 0;
    sessionData.missed_whacks = 0;
    sessionData.appearances = [];
    sessionData.lastWhackTime = 0;
    sessionData.totalWhackIntervals = 0;
    sessionData.whackIntervalCount = 0;
    sessionData.total_click_duration = 0;
    sessionData.total_visibility_duration = 0;
}

function recordWhack(isHit, clickDuration) {
    sessionData.total_whacks++;
    sessionData.total_click_duration += clickDuration;
    
    if (isHit) {
        sessionData.successful_hits++;
    } else {
        sessionData.missed_whacks++;
    }

    var now = Date.now();
    if (sessionData.lastWhackTime > 0) {
        sessionData.totalWhackIntervals += (now - sessionData.lastWhackTime);
        sessionData.whackIntervalCount++;
    }
    sessionData.lastWhackTime = now;
}

function recordAppearance(shownAtMs, pressDownAtMs, visibilityDuration, pressedDownDuration, wasHit) {
    var pressDownLatencyMs = wasHit ? (pressDownAtMs - shownAtMs) : -1;
    sessionData.total_visibility_duration += visibilityDuration;
    
    var appearance = {
        appearance_id: sessionData.appearances.length + 1,
        shownAtMs: shownAtMs,
        pressDownAtMs: wasHit ? pressDownAtMs : -1,
        PressdownLatencyMs: pressDownLatencyMs,
        visibility_duration: visibilityDuration,
        pressed_down_duration: pressedDownDuration,
        press_vs_visibility_ratio: visibilityDuration > 0 ? (pressedDownDuration / visibilityDuration) : 0,
        was_hit: wasHit
    };
    sessionData.appearances.push(appearance);
}

function getFinalTelemetry() {
    var endTime = Date.now();
    sessionData.total_time_up = (endTime - sessionData.startTime) / 1000;

    var avgReaction = 0;
    var hitCount = 0;
    var reactionTimes = [];
    
    for (var i = 0; i < sessionData.appearances.length; i++) {
        if (sessionData.appearances[i].was_hit) {
            var reaction = sessionData.appearances[i].PressdownLatencyMs;
            avgReaction += reaction;
            reactionTimes.push(reaction);
            hitCount++;
        }
    }
    
    var avgReactionSpeed = hitCount > 0 ? (avgReaction / hitCount) : 0;
    var avgInterval = sessionData.whackIntervalCount > 0 ? (sessionData.totalWhackIntervals / sessionData.whackIntervalCount) : 0;
    var fingerTappingRate = sessionData.total_time_up > 0 ? (sessionData.total_whacks / sessionData.total_time_up) : 0;

    var accuracy = sessionData.total_whacks > 0 ? (sessionData.successful_hits / sessionData.total_whacks) : 0;
    
    return {
        game_session: {
            total_time_up: sessionData.total_time_up,
            total_whacks: sessionData.total_whacks,
            successful_hits: sessionData.successful_hits,
            missed_whacks: sessionData.missed_whacks,
            total_appearance_count: sessionData.appearances.length,
            total_click_duration_ms: sessionData.total_click_duration,
            total_visibility_duration_ms: sessionData.total_visibility_duration,
            average_reaction_speed: avgReactionSpeed,
            average_interval_between_whacks: avgInterval,
            finger_tapping_rate: fingerTappingRate,
            metrics: {
                attention_span: sessionData.successful_hits * 2,
                impulse_control: accuracy,
                accuracy_level: accuracy,
                concentration_level: hitCount > 0 ? (1 / (Math.sqrt(reactionTimes.reduce((a, b) => a + Math.pow(b - avgReactionSpeed, 2), 0) / hitCount) + 1)) : 0,
                processing_speed: avgReactionSpeed > 0 ? (1000 / avgReactionSpeed) : 0,
                reaction_speed: avgReactionSpeed,
                frequency: fingerTappingRate
            },
            appearances: sessionData.appearances
        }
    };
}
