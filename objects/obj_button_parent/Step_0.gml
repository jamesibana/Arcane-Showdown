hovering = point_in_rectangle(
   mouse_x, mouse_y,
   x - 90, y - 25,
   x + 90, y + 25
);
if (hovering)
   target_scale = 1.04;
else
   target_scale = 1.0;
scale_amt = lerp(scale_amt, target_scale, 0.15);