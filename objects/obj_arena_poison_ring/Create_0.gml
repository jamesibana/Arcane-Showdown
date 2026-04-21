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

min_w = 600;
min_h = 600;

shrink_speed = 0.25;

damage = 2;
tick_rate = 30;
dmg_tick = 0;

zone_interval = room_speed * 4; // starts at 4 seconds
zone_timer = zone_interval;
zone_steps = 0;