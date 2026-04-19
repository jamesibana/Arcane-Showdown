function get_weapon(_key) {
    if (is_struct(global.weapon_data) && variable_struct_exists(global.weapon_data, _key)) {
        return variable_struct_get(global.weapon_data, _key);
    }
    return undefined;
}

// =====================
// BASE STATS
// =====================
hp = 100;
move_speed = 4;
initialized = false;

owner_player = 0;
character_data = undefined;
attack_cooldown = 0;

// =====================
// INVENTORY INIT (CRITICAL FIX)
// =====================
swap_cooldown = 0;
weapon_melee = "sword";
weapon_ranged = "bow";

weapon_melee_data = get_weapon(weapon_melee);
weapon_ranged_data = get_weapon(weapon_ranged);

// HARD SAFETY (prevents undefined drift)
if (weapon_melee_data == undefined) weapon_melee_data = get_weapon("sword");
if (weapon_ranged_data == undefined) weapon_ranged_data = get_weapon("bow");

active_weapon_type = "melee";

// =====================
// ACTIVE WEAPON INIT
// =====================

current_weapon_data = weapon_melee_data;

weapon_sprite = current_weapon_data.sprite;
damage = current_weapon_data.damage;
cooldown = current_weapon_data.cooldown;
range = current_weapon_data.range;

