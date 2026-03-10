import QtQuick 2.15

QtObject {
    id: phonicsData

    property var sounds: [
        // Level 1: Single Letter Sounds (a-m)
        { "sound": "a", "word": "apple", "image": "🍎", "level": 1 },
        { "sound": "b", "word": "ball", "image": "⚽", "level": 1 },
        { "sound": "c", "word": "cat", "image": "🐱", "level": 1 },
        { "sound": "d", "word": "dog", "image": "🐶", "level": 1 },
        { "sound": "e", "word": "egg", "image": "🥚", "level": 1 },
        { "sound": "f", "word": "fish", "image": "🐟", "level": 1 },
        { "sound": "g", "word": "goat", "image": "🐐", "level": 1 },
        { "sound": "h", "word": "hat", "image": "🎩", "level": 1 },
        { "sound": "i", "word": "igloo", "image": "❄️", "level": 1 },
        { "sound": "j", "word": "jam", "image": "🍯", "level": 1 },
        { "sound": "k", "word": "kite", "image": "🪁", "level": 1 },
        { "sound": "l", "word": "lion", "image": "🦁", "level": 1 },
        { "sound": "m", "word": "monkey", "image": "🐒", "level": 1 },

        // Level 2: Single Letter Sounds (n-z)
        { "sound": "n", "word": "nest", "image": "🪹", "level": 2 },
        { "sound": "o", "word": "octopus", "image": "🐙", "level": 2 },
        { "sound": "p", "word": "pig", "image": "🐷", "level": 2 },
        { "sound": "q", "word": "queen", "image": "👸", "level": 2 },
        { "sound": "r", "word": "rabbit", "image": "🐰", "level": 2 },
        { "sound": "s", "word": "sun", "image": "☀️", "level": 2 },
        { "sound": "t", "word": "tiger", "image": "🐯", "level": 2 },
        { "sound": "u", "word": "umbrella", "image": "☂️", "level": 2 },
        { "sound": "v", "word": "van", "image": "🚐", "level": 2 },
        { "sound": "w", "word": "whale", "image": "🐋", "level": 2 },
        { "sound": "x", "word": "box", "image": "📦", "level": 2 },
        { "sound": "y", "word": "yo-yo", "image": "🪀", "level": 2 },
        { "sound": "z", "word": "zebra", "image": "🦓", "level": 2 },

        // Level 3: Consonant Digraphs (ch, sh, th)
        { "sound": "ch", "word": "chair", "image": "🪑", "level": 3 },
        { "sound": "sh", "word": "ship", "image": "🚢", "level": 3 },
        { "sound": "th", "word": "thin", "image": "📏", "level": 3 },

        // Level 4: Consonant Digraphs (wh, ph, ck, ng, nk)
        { "sound": "wh", "word": "whale", "image": "🐋", "level": 4 },
        { "sound": "ph", "word": "phone", "image": "📱", "level": 4 },
        { "sound": "ck", "word": "duck", "image": "🦆", "level": 4 },
        { "sound": "ng", "word": "sing", "image": "🎤", "level": 4 },
        { "sound": "nk", "word": "bank", "image": "🏦", "level": 4 },

        // Level 5: Vowel Digraphs (ee, oo, ai, ay)
        { "sound": "ee", "word": "tree", "image": "🌳", "level": 5 },
        { "sound": "oo", "word": "moon", "image": "🌙", "level": 5 },
        { "sound": "ai", "word": "rain", "image": "🌧️", "level": 5 },
        { "sound": "ay", "word": "play", "image": "⚽", "level": 5 },

        // Level 6: Vowel Digraphs (oa, oi, oy, au, aw)
        { "sound": "oa", "word": "boat", "image": "⛵", "level": 6 },
        { "sound": "oi", "word": "coin", "image": "🪙", "level": 6 },
        { "sound": "oy", "word": "toy", "image": "🧸", "level": 6 },
        { "sound": "au", "word": "haul", "image": "🚚", "level": 6 },
        { "sound": "aw", "word": "saw", "image": "🪚", "level": 6 },

        // Level 7: Vowel Digraphs (ou, ow) & R-controlled (ar, er)
        { "sound": "ou", "word": "cloud", "image": "☁️", "level": 7 },
        { "sound": "ow", "word": "cow", "image": "🐄", "level": 7 },
        { "sound": "ar", "word": "car", "image": "🚗", "level": 7 },
        { "sound": "er", "word": "her", "image": "👩", "level": 7 },

        // Level 8: R-controlled (ir, ur)
        { "sound": "ir", "word": "bird", "image": "🐦", "level": 8 },
        { "sound": "ur", "word": "fur", "image": "🧥", "level": 8 }
    ]
}
