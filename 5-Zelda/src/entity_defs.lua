--[[
	GD50
	Legend of Zelda

	Author: Colton Ogden
	cogden@cs50.harvard.edu
]]

ENTITY_DEFS = {
	['player'] = {
		walkSpeed = PLAYER_WALK_SPEED,
		hitbox = {
			padX = 1,
			padY = 11,
			width = 13,
			height = 9,
		},
		hurtbox = {
			padX = 1,
			padY = 11,
			width = 13,
			height = 9,
		},
		animations = {
			['walk-left'] = {
				frames = {13, 14, 15, 16},
				interval = 0.155,
				texture = 'character-walk'
			},
			['walk-right'] = {
				frames = {5, 6, 7, 8},
				interval = 0.15,
				texture = 'character-walk'
			},
			['walk-down'] = {
				frames = {1, 2, 3, 4},
				interval = 0.15,
				texture = 'character-walk'
			},
			['walk-up'] = {
				frames = {9, 10, 11, 12},
				interval = 0.15,
				texture = 'character-walk'
			},
			['idle-left'] = {
				frames = {13},
				texture = 'character-walk'
			},
			['idle-right'] = {
				frames = {5},
				texture = 'character-walk'
			},
			['idle-down'] = {
				frames = {1},
				texture = 'character-walk'
			},
			['idle-up'] = {
				frames = {9},
				texture = 'character-walk'
			},
			['hold-left'] = {
				frames = {12},
				texture = 'character-lift'
			},
			['hold-right'] = {
				frames = {6},
				texture = 'character-lift'
			},
			['hold-down'] = {
				frames = {3},
				texture = 'character-lift'
			},
			['hold-up'] = {
				frames = {9},
				texture = 'character-lift'
			},
			['sword-left'] = {
				frames = {13, 14, 15, 16},
				interval = 0.05,
				looping = false,
				texture = 'character-swing-sword'
			},
			['sword-right'] = {
				frames = {9, 10, 11, 12},
				interval = 0.05,
				looping = false,
				texture = 'character-swing-sword'
			},
			['sword-down'] = {
				frames = {1, 2, 3, 4},
				interval = 0.05,
				looping = false,
				texture = 'character-swing-sword'
			},
			['sword-up'] = {
				frames = {5, 6, 7, 8},
				interval = 0.05,
				looping = false,
				texture = 'character-swing-sword'
			},

            ['lift-left'] = {
				frames = {10, 11, 12},
				interval = PLAYER_LIFT_SPEED,
				looping = false,
				texture = 'character-lift'
			},
			['lift-right'] = {
				frames = {4, 5, 6},
				interval = PLAYER_LIFT_SPEED,
				looping = false,
				texture = 'character-lift'
			},
			['lift-down'] = {
				frames = {1, 2, 3},
				interval = PLAYER_LIFT_SPEED,
				looping = false,
				texture = 'character-lift'
			},
			['lift-up'] = {
				frames = {7, 8, 9},
				interval = PLAYER_LIFT_SPEED,
				looping = false,
				texture = 'character-lift'
			},
			['carry-left'] = {
				frames = {13, 14, 15, 16},
				interval = 0.15,
				texture = 'character-carry'
			},
			['carry-right'] = {
				frames = {5, 6, 7, 8},
				interval = 0.15,
				texture = 'character-carry'
			},
			['carry-down'] = {
				frames = {1, 2, 3, 4},
				interval = 0.15,
				texture = 'character-carry'
			},
			['carry-up'] = {
				frames = {9, 10, 11, 12},
				interval = 0.15,
				texture = 'character-carry'
			},
			['throw-left'] = {
				frames = {12, 11, 10},
				interval = PLAYER_THROW_SPEED,
				looping = false,
				texture = 'character-lift'
			},
			['throw-right'] = {
				frames = {6, 5, 4},
				interval = PLAYER_THROW_SPEED,
				looping = false,
				texture = 'character-lift'
			},
			['throw-down'] = {
				frames = {3, 2, 1},
				interval = PLAYER_THROW_SPEED,
				looping = false,
				texture = 'character-lift'
			},
			['throw-up'] = {
				frames = {9, 8, 7},
				interval = PLAYER_THROW_SPEED,
				looping = false,
				texture = 'character-lift'
			}
		}
	},
	['skeleton'] = {
		texture = 'entities',
		hitbox = {
			padX = 4,
			padY = 6,
			width = 7,
			height = 10,
		},
		hurtbox = {
			padX = 4,
			padY = 6,
			width = 7,
			height = 10,
		},
		animations = {
			['walk-left'] = {
				frames = {22, 23, 24, 23},
				interval = 0.2
			},
			['walk-right'] = {
				frames = {34, 35, 36, 35},
				interval = 0.2
			},
			['walk-down'] = {
				frames = {10, 11, 12, 11},
				interval = 0.2
			},
			['walk-up'] = {
				frames = {46, 47, 48, 47},
				interval = 0.2
			},
			['idle-left'] = {
				frames = {23}
			},
			['idle-right'] = {
				frames = {35}
			},
			['idle-down'] = {
				frames = {11}
			},
			['idle-up'] = {
				frames = {47}
			}
		}
	},
	['slime'] = {
		texture = 'entities',
		hitbox = {
			padX = 2,
			padY = 5,
			width = 12,
			height = 9,
		},
		hurtbox = {
			padX = 2,
			padY = 5,
			width = 12,
			height = 9,
		},
		animations = {
			['walk-left'] = {
				frames = {61, 62, 63, 62},
				interval = 0.2
			},
			['walk-right'] = {
				frames = {73, 74, 75, 74},
				interval = 0.2
			},
			['walk-down'] = {
				frames = {49, 50, 51, 50},
				interval = 0.2
			},
			['walk-up'] = {
				frames = {86, 86, 87, 86},
				interval = 0.2
			},
			['idle-left'] = {
				frames = {62}
			},
			['idle-right'] = {
				frames = {74}
			},
			['idle-down'] = {
				frames = {50}
			},
			['idle-up'] = {
				frames = {86}
			}
		}
	},
	['bat'] = {
		texture = 'entities',
		hitbox = {
			padX = 5,
			padY = 4,
			width = 6,
			height = 7,
		},
		hurtbox = {
			padX = 5,
			padY = 4,
			width = 6,
			height = 7,
		},
		animations = {
			['walk-left'] = {
				frames = {64, 65, 66, 65},
				interval = 0.2
			},
			['walk-right'] = {
				frames = {76, 77, 78, 77},
				interval = 0.2
			},
			['walk-down'] = {
				frames = {52, 53, 54, 53},
				interval = 0.2
			},
			['walk-up'] = {
				frames = {88, 89, 90, 89},
				interval = 0.2
			},
			['idle-left'] = {
				frames = {64, 65, 66, 65},
				interval = 0.2
			},
			['idle-right'] = {
				frames = {76, 77, 78, 77},
				interval = 0.2
			},
			['idle-down'] = {
				frames = {52, 53, 54, 53},
				interval = 0.2
			},
			['idle-up'] = {
				frames = {88, 89, 90, 89},
				interval = 0.2
			}
		}
	},
	['ghost'] = {
		texture = 'entities',
		hitbox = {
			padX = 2,
			padY = 1,
			width = 11,
			height = 12,
		},
		hurtbox = {
			padX = 2,
			padY = 1,
			width = 11,
			height = 12,
		},
		animations = {
			['walk-left'] = {
				frames = {67, 68, 69, 68},
				interval = 0.2
			},
			['walk-right'] = {
				frames = {79, 80, 81, 80},
				interval = 0.2
			},
			['walk-down'] = {
				frames = {55, 56, 57, 56},
				interval = 0.2
			},
			['walk-up'] = {
				frames = {91, 92, 93, 92},
				interval = 0.2
			},
			['idle-left'] = {
				frames = {68}
			},
			['idle-right'] = {
				frames = {80}
			},
			['idle-down'] = {
				frames = {56}
			},
			['idle-up'] = {
				frames = {92}
			}
		}
	},
	['spider'] = {
		texture = 'entities',
		hitbox = {
			padX = 3,
			padY = 7,
			width = 9,
			height = 8,
		},
		hurtbox = {
			padX = 3,
			padY = 7,
			width = 9,
			height = 8,
		},
		animations = {
			['walk-left'] = {
				frames = {70, 71, 72, 71},
				interval = 0.2
			},
			['walk-right'] = {
				frames = {82, 83, 84, 83},
				interval = 0.2
			},
			['walk-down'] = {
				frames = {58, 59, 60, 59},
				interval = 0.2
			},
			['walk-up'] = {
				frames = {94, 95, 96, 95},
				interval = 0.2
			},
			['idle-left'] = {
				frames = {71}
			},
			['idle-right'] = {
				frames = {83}
			},
			['idle-down'] = {
				frames = {59}
			},
			['idle-up'] = {
				frames = {95}
			}
		}
	}
}
