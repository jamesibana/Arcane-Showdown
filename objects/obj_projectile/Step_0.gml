x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

if (place_meeting(x, y, obj_enemy_minion)) {

    var hit = instance_place(x, y, obj_enemy_minion);

    if (hit != noone) {
        with (hit) {
            hp -= other.damage;
        }
    }

    instance_destroy();
}