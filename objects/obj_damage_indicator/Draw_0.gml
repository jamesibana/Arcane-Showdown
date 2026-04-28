// 1. Set the font and alignment
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_damage); // 👈 Make sure this is your font name!

var txt = string(damage);
var thick = 2; // ⚙️ ADJUST THIS: How thick you want the outline (in pixels)
var out_color = c_black; // ⚙️ ADJUST THIS: Outline color

// ==========================================
// ⬛ DRAW THE OUTLINE FIRST
// ==========================================
// Draw Left, Right, Up, and Down
draw_text_transformed_color(x - thick, y, txt, scale, scale, 0, out_color, out_color, out_color, out_color, alpha);
draw_text_transformed_color(x + thick, y, txt, scale, scale, 0, out_color, out_color, out_color, out_color, alpha);
draw_text_transformed_color(x, y - thick, txt, scale, scale, 0, out_color, out_color, out_color, out_color, alpha);
draw_text_transformed_color(x, y + thick, txt, scale, scale, 0, out_color, out_color, out_color, out_color, alpha);

// ==========================================
// 🎨 DRAW THE MAIN TEXT ON TOP
// ==========================================
draw_text_transformed_color(x, y, txt, scale, scale, 0, color, color, color, color, alpha);

// Reset alignments so it doesn't break your UI
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ==========================================
// 🧹 CLEAN UP THE STATE!
// ==========================================
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 🛑 THE FIX: Tell GameMaker to stop using fnt_damage!
draw_set_font(-1);