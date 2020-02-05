--[[
	GD50
	Legend of Zelda

	Author: Colton Ogden
	cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
	['switch'] = {
		type = 'switch',
		texture = 'switches',
		frame = 2,
		width = 16,
		height = 16,
		solid = false,
		defaultState = 'unpressed',
		states = {
			['unpressed'] = {
				frame = 2
			},
			['pressed'] = {
				frame = 1
			}
		},
		liftable = false
	},

	['pot'] = {
		type = 'pot',
		texture = 'tiles',
		frame = 16,
		width = 16,
		height = 16,
		solid = true,
		defaultState = 'unbroken',
		states = {
			['unbroken'] = {
				frame = 16
			},
			['broken'] = {
				frame = 54
			}
		},
		onCollide = function(player, object)
		end,

        liftable = true
    },
    
	['heart'] = {
		type = 'heart',
		texture = 'hearts',
        frame = 5,
        -- the heart objects are 8x8
		width = 8,
        height = 8,
        scale = 0.5,
		solid = false,
		defaultState = 'normal',
		states = {
			['normal'] = {
				frame = 5
			}
		},
		onCollide = function(player, object)
			if object.consumed == false then
				gSounds['heart']:play()
				player.health = math.min(player.health + 2, PLAYER_MAX_HEALTH)
				object.consumed = true
			end
		end,

        liftable = false
	}
}
