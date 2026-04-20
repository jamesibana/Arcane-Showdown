
// =====================
// BASE STATS
// =====================
max_hp = 100;
hp = max_hp;

max_armor = 50;
armor = max_armor;

hurt_timer = 0;

move_speed = 4;
initialized = false;

owner_player = 0;
character_data = undefined;

attack_cooldown = 0;
swap_cooldown = 0;

facing_dir = 0;
last_move_key = -1;
last_move_timer = 0;
last_move_count = 0;

// =====================
// INVENTORY INIT
// =====================
weapon_melee = "sword";
weapon_ranged = "bow";

weapon_melee_data = get_weapon(weapon_melee);
weapon_ranged_data = get_weapon(weapon_ranged);

// fallback safety
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

// =====================
// INPUT HELPERS
// =====================
a_tap_timer = 0;
a_tap_count = 0;

