--[[
	GD50
	Legend of Zelda

	Author: Colton Ogden
	cogden@cs50.harvard.edu
]]

Hitbox = Class{}

function Hitbox:init(params)
	self.x = params.x
	self.y = params.y
	self.padX = params.padX
	self.padY = params.padY
	self.width = params.width
	self.height = params.height
end

-- Moves the hitbox with the entity it is attached to
function Hitbox:move(x, y)
	self.x = x + self.padX
	self.y = y + self.padY
end


function Hitbox:collides(target)
	return not (self.x + self.width < target.x or self.x > target.x + target.width or
				self.y + self.height < target.y or self.y > target.y + target.height)
end
