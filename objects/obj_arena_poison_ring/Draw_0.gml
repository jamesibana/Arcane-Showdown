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
var frame = floor(current_time / 100) % frame_count;

var drift = sin(current_time / 300) * 3;

// ============================
// SAFE ZONE BOUNDS
// ============================
var left   = zone_x - zone_w * 0.5;
var right  = zone_x + zone_w * 0.5;
var top    = zone_y - zone_h * 0.5;
var bottom = zone_y + zone_h * 0.5;

// =====================================================
// 💨 SET OPACITY
// =====================================================
// 1 = completely solid, 0.5 = 50% see-through, 0 = invisible
draw_set_alpha(0.67); 

// =====================================================
// LEFT AREA (FULL COVERAGE)
// =====================================================
for (var lx = 0; lx < left; lx += sw) {
    for (var ly = 0; ly < room_height; ly += sh) {

        draw_sprite(
            spr,
            frame,
            lx + drift,
            ly
        );
    }
}

// =====================================================
// RIGHT AREA
// =====================================================
for (var rx = right; rx < room_width; rx += sw) {
    for (var ry = 0; ry < room_height; ry += sh) {

        draw_sprite(
            spr,
            frame,
            rx + drift,
            ry
        );
    }
}

// =====================================================
// 🛑 RESET OPACITY (CRITICAL)
// =====================================================
draw_set_alpha(1);