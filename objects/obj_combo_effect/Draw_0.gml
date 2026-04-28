// =====================================================
// THE GLOW TRICK (ADDITIVE BLENDING)
// =====================================================

// 1. Turn on additive math (makes bright colors glow violently!)
gpu_set_blendmode(bm_add); 

// 2. Draw the sprite exactly as it normally would
draw_self(); 

// 3. 🛑 CRITICAL: Turn blending back to normal immediately!
// If you forget this, your entire game UI and level will start glowing.
gpu_set_blendmode(bm_normal);