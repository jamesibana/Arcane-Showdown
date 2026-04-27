pulse_time += pulse_speed;

image_speed = 0;
switch (image_index)
{
	case 0: image_speed = 0; break; // static
	case 1: image_speed = 0.15; if (image_index >= 2) image_speed  = 0; break;
	case 2: image_speed = 0.25; if (image_index >= 3) image_speed  = 0; break;
	case 3: image_speed = 0.1; break; // idle  glow loop
	
}