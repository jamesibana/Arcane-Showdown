// ============================
// ONLY IN ARENA
// ============================
if (room != rm_arena) exit;


// ============================
// TIMER SYSTEM
// ============================
zone_timer--;

if (zone_timer <= 0) {

    zone_timer = zone_interval;

    // shrink ONLY horizontally
    zone_w = max(min_w, zone_w - shrink_step);

    zone_steps++;

    // faster intervals over time
    if (zone_steps mod 2 == 0) {
        zone_interval = max(room_speed, zone_interval - room_speed);
    }
}


// ============================
// BOUNDS (STORE AS INSTANCE VARS)
// ============================
left   = zone_x - zone_w * 0.5;
right  = zone_x + zone_w * 0.5;
top    = zone_y - zone_h * 0.5;
bottom = zone_y + zone_h * 0.5;


// ============================
// DAMAGE TIMER
// ============================
dmg_tick++;

if (dmg_tick >= tick_rate) {
    dmg_tick = 0;

    // PLAYER 1
with (obj_player1) {

    if (x < other.left || x > other.right) {
        hp -= other.damage;
        hurt_timer = 10;
    }
}
}