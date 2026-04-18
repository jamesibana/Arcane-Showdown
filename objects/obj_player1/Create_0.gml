//Player Data
owner_player = 0;
character_data = undefined;

hp = 100;
move_speed = 4;
initialized = false;

weapon_sprite = spr_sword; // fallback default

/// =====================
/// WEAPON DATABASE
/// =====================

weapon_data = {
    melee: {
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
    }
};

/// =====================
/// CURRENT WEAPON STATE
/// =====================

current_weapon = "melee";
current_weapon_data = weapon_data[$ current_weapon];
weapon_sprite = current_weapon_data.sprite;

/// =====================
/// PLAYER BASE STATS
/// =====================

hp = 100;
move_speed = 4;
owner_player = 0;
character_data = undefined;
initialized = false;