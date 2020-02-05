--[[
	GD50
	Legend of Zelda

	Author: Colton Ogden
	cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
	Entity.init(self, def)
end

function Player:update(dt)
	Entity.update(self, dt)
	if love.keyboard.wasPressed('space') then
		self.stateMachine.current:action(dt)
	end
end

function Player:collides(target)
	-- Triggers for everything but doorways
	if target.room == nil then
		return not (self.hurtbox.x + self.hurtbox.width < target.x or self.hurtbox.x > target.x + target.width or
					self.hurtbox.y + self.hurtbox.height < target.y or self.hurtbox.y > target.y + target.height)

	-- Triggers for doorways only. Allows doorway logic to be separate from hurtboxes
	else
		return not (self.x + self.width < target.x or self.x > target.x + target.width or
					self.hurtbox.y + self.hurtbox.height < target.y or self.hurtbox.y > target.y + target.height)
	end
end

function Player:render()

	Entity.render(self)
end
