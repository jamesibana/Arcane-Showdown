// Only initialize ONCE
if (!variable_global_exists("characters")) {

    global.characters = [
        { name: "Knight", hp: 100, speed: 4, luck: 1 },
        { name: "Rogue", hp: 80, speed: 6, luck: 1.2 }
    ];
}

// Do NOT set to 0 — use undefined
if (!variable_global_exists("p1_character")) global.p1_character = undefined;
if (!variable_global_exists("p2_character")) global.p2_character = undefined;

if (!variable_global_exists("p1_wins")) global.p1_wins = 0;
if (!variable_global_exists("p2_wins")) global.p2_wins = 0;

// selection state
global.current_player = 1;