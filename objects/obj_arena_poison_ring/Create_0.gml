// ============================
// ARENA POISON ZONE (RECTANGLE)
// ============================

zone_x = room_width / 2;
zone_y = room_height / 2;

// full size of safe zone
zone_w = room_width;
zone_h = room_height;

// minimum safe area
min_w = 200;
min_h = 200;

// shrink speed
shrink_speed = 0.5;
shrink_step = 45;

// damage settings
dmg_tick = 0;
tick_rate = 30;
damage = 2;

image_speed = 0.3;

zone_x = room_width / 2;
zone_y = room_height / 2;

zone_w = room_width;
zone_h = room_height;

// Add a buffer so the billows start hidden.
// room_width + (billow_size * 2) covers the wave peaks.
// Adding an extra 100-200px ensures it's truly off-screen.
var spawn_buffer = 20; 
zone_w = room_width + (45 * 2) + spawn_buffer; 

// Keep height the same if you aren't shrinking vertically
zone_h = room_height;

min_w = 600;
min_h = 600;

shrink_speed = 0.25;

damage = 2;
tick_rate = 30;
dmg_tick = 0;

zone_interval = room_speed * 6; // starts at 6 seconds
zone_timer = zone_interval;
zone_steps = 0;

storm_active_timer = 0;