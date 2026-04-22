pve_timer--;

if (pve_timer <= 0) {
    room_goto(rm_arena);
}

// ==========================================
// DEBUG: SPAWN SPECIFIC WEAPONS
// ==========================================

// 1. Create a mini-function to handle the heavy lifting
var _spawn_wep = function(_name) {
    // Check if the weapon data exists in your global struct
    if (variable_global_exists("weapon_data") && variable_struct_exists(global.weapon_data, _name)) {
        
        var wep_data = global.weapon_data[$ _name]; 
        
        // Spawn it at the mouse cursor for easy testing
        var drop = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
        
        // 🛑 THE FIX: Use the exact variable names your pickup object expects!
        drop.weapon_key = _name; 
        drop.weapon_sprite = wep_data.sprite;
        
    } else {
        show_debug_message("WARNING: Weapon '" + _name + "' not found in global.weapon_data!");
    }
};

// 2. Map your exact keys to your exact weapon names in the struct!
if (keyboard_check_pressed(ord("3"))) _spawn_wep("sword");
if (keyboard_check_pressed(ord("4"))) _spawn_wep("dagger");
if (keyboard_check_pressed(ord("5"))) _spawn_wep("spear");
if (keyboard_check_pressed(ord("6"))) _spawn_wep("mace");

if (keyboard_check_pressed(ord("7"))) _spawn_wep("bow");
if (keyboard_check_pressed(ord("8"))) _spawn_wep("blow_dart");
if (keyboard_check_pressed(ord("9"))) _spawn_wep("crossbow");
if (keyboard_check_pressed(ord("0"))) _spawn_wep("poison_spray");