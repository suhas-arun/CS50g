--[[
	GD50
	Legend of Zelda

	Author: Colton Ogden
	cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
	-- render offset for spaced character sprite
	self.entity.offsetY = 5
	self.entity.offsetX = 0
	self.entity.idle = true
end

function PlayerIdleState:update(dt)
	EntityIdleState.update(self, dt)
end

function PlayerIdleState:update(dt)
	if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
	   love.keyboard.isDown('up') or love.keyboard.isDown('down') then
		self.entity:changeState('walk')
	end
end

function PlayerIdleState:action(dt)
	-- if the player has no item they will check if there is an item in front of them
	if self.entity.item == nil then
		self.entity:attemptLift(dt)
		-- if the player could not lift an item, they swing their sword
		if self.entity.item == nil then
			self.entity:changeState('swing-sword')
		
        else
            -- if the player can lift the item it lifts it
			self.entity:changeState('lift')
		end
    else
        -- if the player is holding a pot they throw it
		self.entity:changeState('throw')
	end
end
