// player data
global.current_player = 1;

global.p1_character = undefined;
global.p2_character = undefined;

//Enemy spawn conditions
global.enemy_kills = 0;
global.spawn_lock = false;

// how many kills before next spawn
global.kills_to_spawn = 3;


// optional: wave system prep
global.current_wave = 1;



// wins system	
global.p1_wins = 0;
global.p2_wins = 0;

// persistence
persistent = true;

global.weapon_data = {
    sword: {
        sprite: spr_sword,
        damage: 10,
        cooldown: 20,
        range: 40
    },

    dagger: {
        sprite: spr_dagger,
        damage: 6,
        cooldown: 10,
        range: 30
    },

    spear: {
        sprite: spr_spear,
        damage: 14,
        cooldown: 25,
        range: 70
    },

    mace: {
        sprite: spr_mace,
        damage: 18,
        cooldown: 35,
        range: 40
    },

    bow: {
        sprite: spr_bow,
        damage: 12,
        cooldown: 30,
        range: 200
    },

    crossbow: {
        sprite: spr_crossbow,
        damage: 16,
        cooldown: 40,
        range: 220
    },

    poison_spray: {
        sprite: spr_poison_spray,
        damage: 8,
        cooldown: 15,
        range: 160
    },

    blow_dart: {
        sprite: spr_blow_dart,
        damage: 20,
        cooldown: 45,
        range: 50
    }
};

show_debug_message("weapon_data initialized");