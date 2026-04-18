// player data
global.current_player = 1;

global.p1_character = undefined;
global.p2_character = undefined;

//Enemy spawn conditions
global.enemy_kills = 0;
global.spawn_lock = false;

// how many kills before next spawn
global.kills_to_spawn = 3;


// optional: wave system prep
global.current_wave = 1;



// wins system	
global.p1_wins = 0;
global.p2_wins = 0;

// persistence
persistent = true;