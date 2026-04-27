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
		spr_combo: Anim_Combo_Knight
    },
	   {
        name: "Iron Colossus",
        hp: 300,
		armor: 180,
        speed: 3.5,
        luck: 0.9,
        desc: "Slow tank with high durability",
		unlock_wins: 1,
		sprite: char_player4_Colossus,
		
		spr_move: Anim_Rwalk_Colossus,
		spr_jump: Anim_Jump_Colossus,
		spr_combo: Anim_Combo_Colossus
    },
    {
        name: "Assassin",
        hp: 300,
		armor: 60,
        speed: 6.5,
        luck: 1.0,
        desc: "Speedy but fragile fighter",
		unlock_wins: 5,
		sprite: char_player3_Assassin,
		
		spr_move: Anim_Rwalk_Assassin,
		spr_jump: Anim_Jump_Assassin,
		spr_combo: Anim_Combo_Assassin
    },
    {
        name: "Warlock",
        hp: 300,
		armor: 108,
        speed: 4.5,
        luck: 1.3,
        desc: "High-luck warrior",
		unlock_wins: 8,
		sprite: char_player2_Warlock,
		
		spr_move: spr_indicator_1,
		spr_jump: spr_indicator_1,
		spr_combo: spr_indicator_1
    }
];