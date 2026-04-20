// ===== TIMER =====
state_timer--;

// ===== TARGET =====
var target = instance_nearest(x, y, obj_player1);

var dist_to_player = 99999;
if (target != noone) {
    dist_to_player = point_distance(x, y, target.x, target.y);
}

var dist_from_home = point_distance(x, y, home_x, home_y);

// ===== STATE MACHINE =====

// ENTER CHASE
if (state != "chase" && state_timer <= 0 &&
    dist_to_player <= aggro_enter && dist_from_home <= leash_max) {

    state = "chase";
    state_timer = 15;
}

// EXIT CHASE → RETURN
if (state == "chase" && state_timer <= 0 &&
    (dist_to_player > aggro_exit || dist_from_home > leash_max)) {

    state = "return";
    state_timer = 15;
}

// RETURN COMPLETE → SNAP HOME
if (state == "return" && dist_from_home <= 2) {
    x = home_x;
    y = home_y;
    state = "idle";
}

// ===== MOVEMENT =====
var hsp = 0;
var vsp = 0;

// CHASE PLAYER
if (state == "chase" && target != noone) {

    var dir = point_direction(x, y, target.x, target.y);

    hsp = lengthdir_x(move_speed, dir);
    vsp = lengthdir_y(move_speed, dir);
}

// RETURN TO SPAWN
else if (state == "return") {

    var dir = point_direction(x, y, home_x, home_y);

    hsp = lengthdir_x(move_speed, dir);
    vsp = lengthdir_y(move_speed, dir);
}

if (keyboard_check_pressed(ord("1"))) {
    instance_destroy();
}

if (hp <= 0) {
    instance_destroy();
}


// SMALL JITTER GUARD
if (abs(hsp) < 0.05) hsp = 0;
if (abs(vsp) < 0.05) vsp = 0;

// COLLISION MOVEMENT
if (!place_meeting(x + hsp, y, obj_wall_segment)) x += hsp;
if (!place_meeting(x, y + vsp, obj_wall_segment)) y += vsp;

if (poison_timer > 0) {

    poison_timer--;

    poison_tick++;

    if (poison_tick >= 15) { // damage every 15 frames
        hp -= 1; // or scale this
        poison_tick = 0;
    }
}