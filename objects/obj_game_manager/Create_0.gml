// player data
global.current_player = 1;

global.p1_character = undefined;
global.p2_character = undefined;

//Enemy spawn conditions
global.enemy_kills = 0;
global.spawn_lock = false;

global.spawner_list = [];
global.initial_spawn_done = false;

global.time_spawn_timer = 90  * 5; // first spawn after 5s
global.time_spawn_interval = room_speed * 8; // repeat every 8s

// how many kills before next spawn
global.kills_to_spawn = 3;


// optional: wave system prep
global.current_wave = 1;

// hitpause init
global.hitpause = 0;

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
        range: 65,
		combo: 18,
		combo_fx: Anim_Slash_Melee
    },

    dagger: {
		type: "melee",
        sprite: spr_dagger,
        damage: 6,
        cooldown: 10,
        range: 35,
		combo: 12,
		combo_fx: Anim_Poke_Melee
    },

    spear: {
		type: "melee",
        sprite: spr_spear,
        damage: 16,
        cooldown: 55,
        range: 110,
		combo: 20,
		combo_fx: Anim_Poke_Melee
    },

    mace: {
		type: "melee",
        sprite: spr_mace,
        damage: 12,
        cooldown: 75,
        range: 58,
		combo: 32,
		combo_fx: Anim_Hit_Melee
    },

    bow: {
        type: "ranged",
        sprite: spr_bow,
        projectile_sprite: spr_Bow_Arrow,
        damage: 18,
        cooldown: 65,
        range: 200
    },

    crossbow: {
        type: "ranged",
        sprite: spr_crossbow,
        projectile_sprite: spr_Metal_Arrow,
        damage: 40,
        cooldown: 140,
        range: 220
    },

poison_spray: {
    type: "ranged",
    sprite: spr_poison_spray,
    projectile_sprite: spr_Poison_Cloud,
    damage: 8,
    cooldown: 110,
    range: 40,

    // 🔥 ADD THESE
    proj_speed: 2,
    cloud_lifetime: 120,
    poison_tick: 10,
    poison_damage: 1.75,
	slow_multiplier: 0.6
},

    blow_dart: {
        type: "ranged",
        sprite: spr_blow_dart,
        projectile_sprite: spr_Quick_Dart,
        damage: 8,
        cooldown: 30,
        range: 50
    }
};

randomize();

global.round_active = false;

// Arena player tracking
p1_exists = false;
p2_exists = false;

// =====================================================
// ARENA ROUND SYSTEM INIT
// =====================================================
global.current_round = 1;
global.max_lives = 2; // Change this to 3 or 5 for longer matches!

global.p1_lives = global.max_lives;
global.p2_lives = global.max_lives;