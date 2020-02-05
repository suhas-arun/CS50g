--[[
	GD50
	Legend of Zelda

	Author: Colton Ogden
	cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
	-- string identifying this object type
	self.type = def.type

	self.texture = def.texture
	self.frame = def.frame or 1

	-- whether it acts as an obstacle or not
	self.solid = def.solid

	self.defaultState = def.defaultState
	self.state = self.defaultState
	self.states = def.states

	-- dimensions
	self.x = x
	self.y = y
	self.width = def.width
	self.height = def.height

	if def.onCollide == nil then
		self.onCollide = function(player) end
	else
		self.onCollide = def.onCollide
	end

	self.consumed = false

	self.liftable = def.liftable

	self.broken = false
	self.fireDirection = nil
	self.dx = 0
	self.dy = 0
	self.targetX = 0
	self.targetY = 0
    self.fired = false

    -- hearts have a scale of 0.5 to render them smaller
    self.scale = def.scale
end

function GameObject:update(dt)
	if self.fired then
		if not self.broken then
			if self.fireDirection ~= 'up' and self.y >= self.targetY then
				self:breakPot()
			elseif self.fireDirection == 'up' and self.y <= self.targetY then
				self:breakPot()
			else
				self.x = self.x + self.dx * dt
				self.y = self.y + self.dy * dt
			end
        end
	end
end

function GameObject:fire(direction, destX, destY, speed)
	self.fired = true
	self.fireDirection = direction
	self.targetX = destX
	self.targetY = destY
	self.dx = (self.targetX - self.x) * speed
	self.dy = (self.targetY - self.y) * speed
end

function GameObject:breakPot()
    self.broken = true
    self.state = 'broken'
    gSounds['break']:play()
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY, 0, self.scale or 1)
end
