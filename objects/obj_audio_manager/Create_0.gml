// =====================================================
// 0. THE HIGHLANDER RULE (PREVENT DUPLICATES)
// =====================================================
if (instance_number(object_index) > 1) {	
    instance_destroy();
    exit; // Stop reading the rest of this code!
}

// ... your existing code below ...
global.current_music = noone;
global.target_music = noone;
