// ============================
// ONLY IN ARENA
// ============================
if (room != rm_arena) exit;

// ============================
// BOUNDS CALCULATION
// ============================
// MUST be at the top so the Draw Event always has numbers, 
// even during the "3, 2, 1" countdown!
left   = zone_x - zone_w * 0.5;
right  = zone_x + zone_w * 0.5;
top    = zone_y - zone_h * 0.5;
bottom = zone_y + zone_h * 0.5;

// =====================================================
// ROUND ACTIVE CHECK (NEW)
// =====================================================
// Stop the ring from shrinking or damaging during Start/K.O. screens
if (!global.round_active || global.round_over) exit;

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
        zone_interval = max(room_speed * 1.5, zone_interval - room_speed);
    }
}

// ============================
// DAMAGE TIMER
// ============================
dmg_tick++;

if (dmg_tick >= tick_rate) {
    dmg_tick = 0;

    // PLAYER 1 & 2
    with (obj_player1) {

        if (x < other.left || x > other.right) {
            
            var p_dmg = other.damage;

            // Safety check
            if (!variable_instance_exists(id, "armor")) armor = 0;
            if (!variable_instance_exists(id, "hp")) hp = 1;

            // --- 1. DAMAGE ARMOR FIRST ---
            if (armor > 0) {
                var absorbed = min(armor, p_dmg);
                armor -= absorbed;
                p_dmg -= absorbed;
            }

            // --- 2. DAMAGE HP WITH REMAINDER ---
            if (p_dmg > 0) {
                hp -= p_dmg;
            }

            hurt_timer = 10;
        }
    }
}