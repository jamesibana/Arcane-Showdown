//Player Data
owner_player = 0;
character_data = undefined;

hp = 100;
move_speed = 4;
initialized = false;

weapon_sprite = spr_sword; // fallback default

/// =====================
/// PLAYER BASE STATS
/// =====================

hp = 100;
move_speed = 4;
owner_player = 0;
character_data = undefined;
initialized = false;

current_weapon = "melee";
current_weapon_data = undefined;

weapon_melee = "sword";
weapon_ranged = "bow";

weapon_melee_data = variable_struct_get(global.weapon_data, weapon_melee);
weapon_ranged_data = variable_struct_get(global.weapon_data, weapon_ranged);

active_weapon_type = "melee";

// active stats (what combat uses)
current_weapon_data = weapon_melee_data;
weapon_sprite = current_weapon_data.sprite;

damage = current_weapon_data.damage;
cooldown = current_weapon_data.cooldown;
range = current_weapon_data.range;