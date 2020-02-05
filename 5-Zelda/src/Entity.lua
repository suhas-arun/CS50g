--[[
	GD50
	Legend of Zelda

	Author: Colton Ogden
	cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(def)

	-- in top-down games, there are four directions instead of two
	self.direction = 'down'

	self.animations = self:createAnimations(def.animations)

	-- dimensions
	self.x = def.x
	self.y = def.y
	self.width = def.width
	self.height = def.height

	self.room = def.room

	-- drawing offsets for padded sprites
	self.offsetX = def.offsetX or 0
	self.offsetY = def.offsetY or 0

	self.walkSpeed = def.walkSpeed

	self.health = def.health



	self.hitbox = Hitbox {
		padX = def.hitbox.padX,
		padY = def.hitbox.padY,
		width = def.hitbox.width,
		height = def.hitbox.height
	}
	self.hurtbox = Hitbox {
		padX = def.hurtbox.padX,
		padY = def.hurtbox.padY,
		width = def.hurtbox.width,
		height = def.hurtbox.height,
	}
	-- Setting the absolute coordinates
	self.hitbox:move(self.x, self.y)
	self.hurtbox:move(self.x, self.y)

	-- flags for flashing the entity when hit
	self.invulnerable = false
	self.invulnerableDuration = 0
	self.invulnerableTimer = 0
	self.flashTimer = 0
	self.directionHit = 'none'
	self.dead = false

	-- onDeath function for generating hearts
	self.onDeath = def.onDeath

	self.bumped = false
	self.liftOffsetX = def.liftOffsetX
	self.liftOffsetY = def.liftOffsetY
	self.inLiftRange = false
	self.item = nil
	self.liftHitboxDisplayTimer = 0
end

function Entity:createAnimations(animations)
	local animationsReturned = {}

	for k, animationDef in pairs(animations) do
		animationsReturned[k] = Animation {
			texture = animationDef.texture or 'entities',
			frames = animationDef.frames,
			interval = animationDef.interval
		}
	end

	return animationsReturned
end

--[[
	AABB with some slight shrinkage of the box on the top side for perspective.
]]
function Entity:collides(target)
	return not (self.hurtbox.x + self.hurtbox.width < target.x or self.hurtbox.x > target.x + target.width or
				self.hurtbox.y + self.hurtbox.height < target.y or self.hurtbox.y > target.y + target.height)
end

function Entity:unCollide(target, dt)
	local boxEndX = self.hurtbox.x + self.width
	local boxEndY = self.hurtbox.y + self.height
	local tEndX = target.x + target.width
	local tEndY = target.y + target.height

	if boxEndX >= target.x and self.hurtbox.x <= tEndX then
		if math.abs(boxEndX - target.x) < math.abs(self.hurtbox.x - tEndX) - 4 then -- "- 4" optimal for player
			self.x = self.x - (self.walkSpeed * dt)
		elseif math.abs(boxEndX - target.x) > math.abs(self.hurtbox.x - tEndX) + 8 then -- "+ 8" optimal for player
			self.x = self.x + (self.walkSpeed * dt)
		end
	end
	if boxEndY >= target.y and self.hurtbox.y <= tEndY then
		if math.abs(boxEndY - target.y) < math.abs(self.hurtbox.y - tEndY) + 4 then -- "+ 4" optimal for player
			self.y = self.y - (self.walkSpeed * dt)
		elseif math.abs(boxEndY - target.y) > math.abs(self.hurtbox.y - tEndY) + 15 then -- "+ 15" optimal for player
			self.y = self.y + (self.walkSpeed * dt)
		end
	end
end

function Entity:damage(dmg)
	-- Preventing death loop
	if self.health > 0 then
		self.health = self.health - dmg
        
        if self.health <= 0 then
            self:death()
        end
		
	end
end

function Entity:death()
	-- onDeath function for dropping hearts
	if self.onDeath ~= nil then
		self.onDeath(self)
	end

	self.dead = true
end

function Entity:goInvulnerable(duration)
	self.invulnerable = true
	self.invulnerableDuration = duration
end

function Entity:changeState(name)
	self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
	self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
	if not self.dead then
		if self.invulnerable then
			self.flashTimer = self.flashTimer + dt
			self.invulnerableTimer = self.invulnerableTimer + dt

			if self.invulnerableTimer > self.invulnerableDuration then
				self.invulnerable = false
				self.invulnerableTimer = 0
				self.invulnerableDuration = 0
				self.flashTimer = 0
			end
		end

		self.stateMachine:update(dt)

		self.hurtbox:move(self.x, self.y)
		self.hitbox:move(self.x, self.y)

		if self.currentAnimation then
			self.currentAnimation:update(dt)
		end
	end

	self.liftHitboxDisplayTimer = self.liftHitboxDisplayTimer - dt
end

function Entity:checkObjectCollisions(dt)
    for k, object in pairs(self.room.objects) do
        if object.solid then
            if self:collides(object) then
                self.bumped = true
                self:unCollide(object, dt)
            end
        end
    end
end

function Entity:attemptLift(dt)
	-- Creating a special hitbox for the lift
	local padX, padY, hitboxWidth, hitboxHeight
	if self.direction == 'left' then
		hitboxWidth = 5
		hitboxHeight = 5
		padX = -hitboxWidth + self.hurtbox.padX
		padY = self.hurtbox.padY + self.hurtbox.height - 5
	elseif self.direction == 'right' then
		hitboxWidth = 5
		hitboxHeight = 5
		padX = self.hurtbox.width + self.hurtbox.padX
		padY = self.hurtbox.padY + self.hurtbox.height - 5
	elseif self.direction == 'up' then
		hitboxWidth = 5
		hitboxHeight = 5
		padX = self.hurtbox.padX + self.hurtbox.width / 4 + 1
		padY = self.hurtbox.padY - 5
	else
		hitboxWidth = 5
		hitboxHeight = 5
		padX = self.hurtbox.padX + self.hurtbox.width / 4 + 1
		padY = self.hurtbox.padY + self.hurtbox.height
	end

	self.liftHitbox = Hitbox {
		padX = padX,
		padY = padY,
		height = hitboxHeight,
		width = hitboxWidth
	}
	self.liftHitbox:move(self.x, self.y)

	for k, object in pairs(self.room.objects) do
		if self.liftHitbox:collides(object) and object.liftable then
			self.item = object
			table.remove(self.room.objects, k)
			break
		end
		if self.item then
			break
		end
	end

	-- Timer to display the lift hitbox
	self.liftHitboxDisplayTimer = 1
end

function Entity:processAI(dt)
	self.stateMachine:processAI(dt)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
	if not self.dead then

		if self.damageFlash and not self.invulnerable then
			 love.graphics.setColor(255, 0, 0, 255)
		-- draw sprite slightly transparent if invulnerable every 0.04 seconds
		elseif self.invulnerable and self.flashTimer > 0.06 then
			self.flashTimer = 0
			love.graphics.setColor(255, 255, 255, 64)
		end

		self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)

		self.stateMachine:render()
		love.graphics.setColor(255, 255, 255, 255)
		self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
	end
end
