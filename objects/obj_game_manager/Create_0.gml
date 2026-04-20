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
if (!variable_global_exists("p1_wins")) {
    global.p1_wins = 0;
}

if (!variable_global_exists("p2_wins")) {
    global.p2_wins = 0;
}

// persistence
persistent = true;

global.weapon_data = {
    sword: {
		type: "melee",
        sprite: spr_sword,
        damage: 10,
        cooldown: 20,
        range: 40
    },

    dagger: {
		type: "melee",
        sprite: spr_dagger,
        damage: 6,
        cooldown: 10,
        range: 30
    },

    spear: {
		type: "melee",
        sprite: spr_spear,
        damage: 14,
        cooldown: 25,
        range: 70
    },

    mace: {
		type: "melee",
        sprite: spr_mace,
        damage: 18,
        cooldown: 35,
        range: 40
    },

    bow: {
        type: "ranged",
        sprite: spr_bow,
        projectile_sprite: spr_Bow_Arrow,
        damage: 12,
        cooldown: 30,
        range: 200
    },

    crossbow: {
        type: "ranged",
        sprite: spr_crossbow,
        projectile_sprite: spr_Metal_Arrow,
        damage: 16,
        cooldown: 40,
        range: 220
    },

poison_spray: {
    type: "ranged",
    sprite: spr_poison_spray,
    projectile_sprite: spr_Poison_Cloud,
    damage: 8,
    cooldown: 15,
    range: 160,

    // 🔥 ADD THESE
    proj_speed: 2,
    cloud_lifetime: 120,
    poison_tick: 10,
    poison_damage: 1
},

    blow_dart: {
        type: "ranged",
        sprite: spr_blow_dart,
        projectile_sprite: spr_Quick_Dart,
        damage: 20,
        cooldown: 45,
        range: 50
    }
};




show_debug_message("weapon_data initialized");

