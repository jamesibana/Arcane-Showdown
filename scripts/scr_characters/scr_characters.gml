global.characters = [
    {
        name: "Vanguard Knight",
        hp: 300,
		armor: 120,
        speed: 5,
        luck: 1.0,
        desc: "Basic default fighter",
		unlock_wins: 0,
		sprite: char_player1_Knight,
		
		spr_move: Anim_Rwalk_Knight,
		spr_jump: Anim_Jump_Knight,
		spr_combo: Anim_Combo_Knight,
		spr_attack: Anim_ATK_Knight
    },
	   {
        name: "Iron Colossus",
        hp: 300,
		armor: 180,
        speed: 4.2,
        luck: 0.9,
        desc: "Slow tank with high durability",
		unlock_wins: 1,
		sprite: char_player4_Colossus,
		
		spr_move: Anim_Rwalk_Colossus,
		spr_jump: Anim_Jump_Colossus,
		spr_combo: Anim_Combo_Colossus,
		spr_attack: Anim_ATK_Colossus
    },
    {
        name: "Assassin",
        hp: 300,
		armor: 80,
        speed: 6,
        luck: 1.0,
        desc: "Speedy but fragile fighter",
		unlock_wins: 5,
		sprite: char_player3_Assassin,
		
		spr_move: Anim_Rwalk_Assassin,
		spr_jump: Anim_Jump_Assassin,
		spr_combo: Anim_Combo_Assassin,
		spr_attack: Anim_ATK_Assassin
    },
    {
        name: "Warlock",
        hp: 300,
		armor: 108,
        speed: 4.5,
        luck: 1.5,
        desc: "High-luck warrior",
		unlock_wins: 8,
		sprite: char_player2_Warlock,
		
		spr_move: Anim_Rwalk_Warlock,
		spr_jump: Anim_Jump_Warlock,
		spr_combo: Anim_Combo_Warlock,
		spr_attack: Anim_ATK_Warlock
    }
];