function get_weapon(_key) {
    if (is_struct(global.weapon_data) && variable_struct_exists(global.weapon_data, _key)) {
        return variable_struct_get(global.weapon_data, _key);
    }
    return undefined;
}