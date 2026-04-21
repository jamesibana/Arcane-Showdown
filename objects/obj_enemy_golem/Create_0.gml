//==================================================

hp = 70;
move_speed = 1.5;
armor = 0;

// Aggro system
aggro_enter = 140;
aggro_exit  = 150;

// Leash system
home_x = x;
home_y = y;
leash_max = 160;

attack_damage = 1;   // 👈 change per enemy
attack_range  = 20;  // optional but recommended
attack_speed  = 30;  // cooldown

sprite_index = spr_MidTier_Golem; // IMPORTANT
//==================================================


// State system
state = "idle";
state_timer = 0;

poison_timer = 0;
poison_tick = 0;

death_timer = 0;
death_duration = 30; // how long death animation lasts

loot_dropped = false;

// HURT FEEDBACK
hurt_timer = 0;

// DEATH STATE
state = "alive";
death_fall_speed = 8;
death_rotation_speed = 8;

//ATTACK
attack_cooldown = 0;
image_blend = c_white;

image_alpha = 1



poison_damage = 1;