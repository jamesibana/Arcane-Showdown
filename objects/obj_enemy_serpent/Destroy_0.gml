// =====================
// KILL COUNT
// =====================
global.enemy_kills += 1;

// =====================
// DROP SETTINGS
// =====================
var drop_chance = 55;

// roll
if (irandom(99) < drop_chance) {

    var names = variable_struct_get_names(global.weapon_data);

    if (array_length(names) > 0) {

        var drop_key = names[irandom(array_length(names) - 1)];
        var data = get_weapon(drop_key);

        if (data != undefined) {

            var drop = instance_create_layer(x, y, "Instances", obj_weapon_pickup);
            drop.weapon_key = drop_key;
            drop.weapon_sprite = data.sprite;
        }
    }
}