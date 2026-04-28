// ============================
// ONLY IN ARENA
// ============================
if (room != rm_arena) exit;

// =====================================================
// 0. SAFE INIT (DYNAMIC PULSATION)
// =====================================================
if (!variable_instance_exists(id, "target_w")) target_w = zone_w; 
if (!variable_instance_exists(id, "start_w")) start_w = zone_w; 

// 🛑 NEW: Remember the starting interval and create a reset flag!
if (!variable_instance_exists(id, "start_interval")) start_interval = zone_interval;
if (!variable_instance_exists(id, "needs_reset")) needs_reset = false; 

// ⚙️ ADJUST THESE VARIABLES:
if (!variable_instance_exists(id, "max_pulse")) max_pulse = 0.25; 
if (!variable_instance_exists(id, "min_pulse")) min_pulse = 0.5; 
if (!variable_instance_exists(id, "pulse_speed")) pulse_speed = 0.015;


// =====================================================
// ROUND ACTIVE CHECK & RESET SYSTEM
// =====================================================
if (!global.round_active || global.round_over) {
    needs_reset = true; // Flag the storm so it knows to reset next round!
    exit;
}

// 🔄 THE FIX: If a new round just started, reset the storm completely!
if (needs_reset) {
    target_w = start_w;
    zone_w = start_w;
    zone_interval = start_interval;
    zone_timer = start_interval;
    zone_steps = 0;
    storm_active_timer = 0;
    dmg_tick = 0;
    
    needs_reset = false; // Pull the flag down so it doesn't infinitely reset
}

// 🕒 Increase the storm timer only when the round is active
storm_active_timer++;


// =====================================================
// 🫁 THE DYNAMIC PULSATING MATH
// =====================================================
// 1. Figure out how far into the match we are (1.0 = Start of match, 0.0 = Smallest zone)
var size_ratio = (target_w - min_w) / max(1, (start_w - min_w)); 

// 2. Smoothly blend between our Min and Max pulse based on that ratio!
var current_pulse = lerp(min_pulse, max_pulse, size_ratio);

// 3. Generate the wave (0.0 to 1.0)
var wave = (sin(storm_active_timer * pulse_speed) * 0.5) + 0.5;

// 4. Apply the wave using our newly calculated dynamic pulse
zone_w = target_w * (1.0 + (wave * current_pulse));


// ============================
// BOUNDS CALCULATION
// ============================
// MUST be at the top so the Draw Event always has numbers, 
// even during the "3, 2, 1" countdown!
left   = zone_x - zone_w * 0.5;
right  = zone_x + zone_w * 0.5;
top    = zone_y - zone_h * 0.5;
bottom = zone_y + zone_h * 0.5;


// ============================
// TIMER SYSTEM
// ============================
zone_timer--;

if (zone_timer <= 0) {

    zone_timer = zone_interval;

    // 🛑 THE FIX: Shrink 'target_w', NOT 'zone_w'
    target_w = max(min_w, target_w - shrink_step);

    zone_steps++;

    // faster intervals over time
    if (zone_steps mod 2 == 0) {
        zone_interval = max(room_speed * 1.5, zone_interval - room_speed);
    }
}

// =====================================================
// 🌪️ POISON RING TRACKER & WIND PULL
// =====================================================
var pull_force = 1; 

with (obj_player1) {
    // 1. Reset the ring flag every frame
    if (!variable_instance_exists(id, "in_poison_ring")) in_poison_ring = false;
    in_poison_ring = false; 
    
    // 2. Apply wind and flag the player if they are in the storm
    if (x < other.left) {
        in_poison_ring = true;
        if (!place_meeting(x - pull_force, y, obj_wall_segment)) x -= pull_force; 
    } 
    else if (x > other.right) {
        in_poison_ring = true;
        if (!place_meeting(x + pull_force, y, obj_wall_segment)) x += pull_force; 
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