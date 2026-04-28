draw_self();

draw_set_font(fnt_menu);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(x, y, button_text);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

var w = 90 * scale_amt;
var h = 24 * scale_amt;
var col = base_col;
if (hovering) col = hover_col;
// shadow
draw_set_alpha(0.25);
draw_set_color(c_black);
draw_roundrect(x-w+4,y-h+4,x+w+4,y+h+4,false);
draw_set_alpha(1);
// button face
draw_set_color(col);
draw_roundrect(x-w,y-h,x+w,y+h,false);
// border
draw_set_color(border_col);
draw_roundrect(x-w,y-h,x+w,y+h,true);
// text
draw_set_color(text_col);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x,y,button_text);

var col;
if (hovering)
{
   col = make_color_rgb(245,220,170); // warm hover
}
else
{
   col = make_color_rgb(205,175,130); // dusty brown normal
}
draw_sprite_ext(sprite_index,image_index,x,y,1,1,0,col,1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(60,35,15));
draw_text(x,y,button_text);
