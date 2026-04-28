direction = 0;
speed = 0;
image_angle = 0;

initialized = false;

// fallback sprite (safe)
sprite_index = spr_Bow_Arrow;

mode = "travel"; // travel → cloud

lifetime = 0;
max_range = 0;
distance_traveled = 0;

image_speed = 0; // default (projectiles don't animate)
cloud_started = false;

cloud_radius = 10;
cloud_max_radius = 60;
cloud_growth = 1.5;