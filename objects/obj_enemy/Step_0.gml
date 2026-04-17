var p = instance_nearest(x, y, obj_player1);

if (p != noone) {
    move_towards_point(p.x, p.y, speed);
}