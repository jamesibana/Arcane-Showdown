// 1. Move the text
x += hsp;
y += vsp;

// 2. Slow down the upward movement slightly over time (friction)
vsp = lerp(vsp, 0, 0.05);

// 3. Make the text "Pop" to full size quickly
scale = lerp(scale, 1.0, 0.2);

// 4. Fade out
alpha -= 0.02; // Fades out over 50 frames

// 5. Destroy when invisible to prevent memory leaks!
if (alpha <= 0) {
    instance_destroy();
}