// ============================
// ONLY IN ARENA
// ============================
if (room != rm_arena) exit;

// ============================
// SPRITE SETUP
// ============================
var spr = spr_sandstorm_arena;
var sw = sprite_get_width(spr);
var sh = sprite_get_height(spr);

var frame_count = max(1, sprite_get_number(spr));

// Smooth animation 
var frame1 = (current_time / 80) % frame_count; 
var frame2 = (current_time / 55) % frame_count; 

// 💨 UPDATED SCROLL (Adjusted for Frames instead of Milliseconds)
// Multiply the speed by roughly 16 to keep the same visual pace
var scroll_x1 = -(storm_active_timer * 2.5) % sw;
var scroll_y1 = (storm_active_timer * 0.8) % sh;

var scroll_x2 = -(storm_active_timer * 1.3) % sw; 
var scroll_y2 = (storm_active_timer * 0.3) % sh;

// ============================
// SAFE ZONE BOUNDS
// ============================
var left  = zone_x - zone_w * 0.5;
var right = zone_x + zone_w * 0.5;

// The maximum amount of pixels the storm edge can billow inward or outward
var billow_size = 45; 

// =====================================================
// LEFT STORM (BILLOWING EDGES)
// =====================================================
var col = 0;
// We only start the loop if the 'left' boundary is actually inside the room
if (left > -billow_size) {
    for (var lx = -sw; lx <= left + (sw * 3); lx += sw) {
        
        var stagger = (col % 2 == 0) ? (sh / 2) : 0;
        
        for (var ly = -sh; ly <= room_height + sh; ly += sh) {
            
            var ax1 = lx + scroll_x1;
            var ay1 = ly + scroll_y1 + stagger;
            
            var wobble1 = sin((ay1 * 0.015) + (storm_active_timer * 0.12)) * billow_size;
            var dynamic_left1 = left + wobble1;
            
            // 🛑 ONLY DRAW if the calculated edge is actually visible!
            if (dynamic_left1 > 0) {
                if (ax1 + sw <= dynamic_left1) {
                    draw_sprite_ext(spr, frame1, ax1, ay1, 1, 1, 0, c_white, 0.5);
                } else if (ax1 < dynamic_left1) {
                    draw_sprite_part_ext(spr, frame1, 0, 0, dynamic_left1 - ax1, sh, ax1, ay1, 1, 1, c_white, 0.5);
                }
            }
            
            // --- LAYER 2 ---
            var ax2 = lx + scroll_x2;
            var ay2 = ly + scroll_y2 + stagger + (sh / 3);
            var wobble2 = sin((ay2 * 0.01) + (storm_active_timer * 0.18)) * billow_size;
            var dynamic_left2 = left + wobble2;
            
            if (dynamic_left2 > 0) {
                if (ax2 + sw <= dynamic_left2) {
                    draw_sprite_ext(spr, frame2, ax2, ay2, 1, 1, 0, c_white, 0.3);
                } else if (ax2 < dynamic_left2) {
                    draw_sprite_part_ext(spr, frame2, 0, 0, dynamic_left2 - ax2, sh, ax2, ay2, 1, 1, c_white, 0.3);
                }
            }
        }
        col++;
    }
}

// =====================================================
// RIGHT STORM (BILLOWING EDGES)
// =====================================================
col = 0;
// We only start the loop if the 'right' boundary has actually entered the room
if (right < room_width + billow_size) {
    for (var rx = right - (sw * 3); rx <= room_width + (sw * 2); rx += sw) {
        
        var stagger = (col % 2 == 0) ? (sh / 2) : 0;
        
        for (var ry = -sh; ry <= room_height + sh; ry += sh) {
            
            var ax1 = rx + scroll_x1;
            var ay1 = ry + scroll_y1 + stagger;
            
            var wobble1 = sin((ay1 * 0.015) + (storm_active_timer * 0.12)) * billow_size;
            var dynamic_right1 = right + wobble1;
            
            // 🛑 ONLY DRAW if the calculated edge is within the room
            if (dynamic_right1 < room_width) {
                if (ax1 >= dynamic_right1) {
                    draw_sprite_ext(spr, frame1, ax1, ay1, 1, 1, 0, c_white, 0.5);
                } else if (ax1 + sw > dynamic_right1) {
                    draw_sprite_part_ext(spr, frame1, dynamic_right1 - ax1, 0, (ax1 + sw) - dynamic_right1, sh, dynamic_right1, ay1, 1, 1, c_white, 0.5);
                }
            }
            
            // --- LAYER 2 ---
            var ax2 = rx + scroll_x2;
            var ay2 = ry + scroll_y2 + stagger + (sh / 3);
            var wobble2 = sin((ay2 * 0.01) + (storm_active_timer * 0.18)) * billow_size;
            var dynamic_right2 = right + wobble2;
            
            if (dynamic_right2 < room_width) {
                if (ax2 >= dynamic_right2) {
                    draw_sprite_ext(spr, frame2, ax2, ay2, 1, 1, 0, c_white, 0.3);
                } else if (ax2 + sw > dynamic_right2) {
                    draw_sprite_part_ext(spr, frame2, dynamic_right2 - ax2, 0, (ax2 + sw) - dynamic_right2, sh, dynamic_right2, ay2, 1, 1, c_white, 0.3);
                }
            }
        }
        col++;
    }
}