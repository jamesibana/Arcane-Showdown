show_debug_message("weapon_data TYPE = " + string(typeof(global.weapon_data)));

global.enemy_kills += 1;

if (irandom(100) < 15) {

    var keys = [
        "sword","dagger","spear","mace",
        "bow","crossbow","blow_dart","poison_spray"
    ];

    var chosen = keys[irandom(array_length(keys) - 1)];

    var drop = instance_create_layer(x, y, "Instances", obj_weapon_pickup);

    drop.weapon_key = chosen;

    // SAFE LOOKUP (single source of truth)
    if (is_struct(global.weapon_data) && variable_struct_exists(global.weapon_data, chosen)) {

        var w = variable_struct_get(global.weapon_data, chosen);
        drop.weapon_sprite = w.sprite;

    } else {

        show_debug_message("INVALID WEAPON OR BROKEN DATA: " + chosen);
        drop.weapon_sprite = spr_wall_collision; // fallback
    }
}