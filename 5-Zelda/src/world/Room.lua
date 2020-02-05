--[[
	GD50
	Legend of Zelda

	Author: Colton Ogden
	cogden@cs50.harvard.edu
]]

Room = Class{}

function Room:init(player, x, y)

	self.width = MAP_WIDTH
	self.height = MAP_HEIGHT

	-- reference to player for collisions, etc.
	self.player = player

	self.playerStartX = math.floor((x - MAP_RENDER_OFFSET_X) / TILE_SIZE)
	self.playerStartY = math.floor((y - MAP_RENDER_OFFSET_Y) / TILE_SIZE)

	-- game objects in the room
	self.objects = {}
	self:generateObjects()

	self.tiles = {}
	self:generateWallsAndFloors()

	-- entities in the room
	self.entities = {}
	self:generateEntities()

	self.pots = {}

	-- doorways that lead to other dungeon rooms
	self.doorways = {}
	table.insert(self.doorways, Doorway('top', false, self))
	table.insert(self.doorways, Doorway('bottom', false, self))
	table.insert(self.doorways, Doorway('left', false, self))
	table.insert(self.doorways, Doorway('right', false, self))

	-- used for centering the dungeon rendering
	self.renderOffsetX = MAP_RENDER_OFFSET_X
	self.renderOffsetY = MAP_RENDER_OFFSET_Y

	-- used for drawing when this room is the next room, adjacent to the active
	self.adjacentOffsetX = 0
	self.adjacentOffsetY = 0

end

--[[
	Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
	local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

	for i = 1, 10 do
		local type = types[math.random(#types)]
		local entityX, entityY = self:getRandomCoords()

		table.insert(self.entities, Entity {
			animations = ENTITY_DEFS[type].animations,
			walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,
			hitbox = ENTITY_DEFS[type].hitbox,
			hurtbox = ENTITY_DEFS[type].hurtbox,
			room = self,

			-- ensure X and Y are within bounds of the map
			x = entityX,
			y = entityY,

			width = 16,
			height = 16,

			health = 1,

            onDeath = function(entity)
                -- there is a 1/4 chance of a heart spawning
				if math.random(4) == 1 then
                    table.insert(self.objects,
                        GameObject(GAME_OBJECT_DEFS['heart'], entity.x, entity.y))
				end
			end
		})

		self.entities[i].stateMachine = StateMachine {
			['walk'] = function() return EntityWalkState(self.entities[i]) end,
			['idle'] = function() return EntityIdleState(self.entities[i]) end
		}

		self.entities[i]:changeState('idle')
	end
end

--[[
	Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()
	local x, y = self:getRandomCoords()
	table.insert(self.objects, GameObject(GAME_OBJECT_DEFS['switch'], x, y))

	-- get a reference to the switch
	local switch = self.objects[1]

	-- define a function for the switch that will open all doors in the room
	switch.onCollide = function()
		if switch.state == 'unpressed' then
			switch.state = 'pressed'

			-- open every door in the room if we press the switch
			for k, doorway in pairs(self.doorways) do
				doorway.open = true
			end

			gSounds['door']:play()
		end
    end

    -- generate pots
    -- there are up to 5 pots per room
	local noPots = math.random(5)
	for i = 0, noPots do
		local x, y = self:getRandomCoords()
		table.insert(self.objects, GameObject(GAME_OBJECT_DEFS['pot'], x, y))
	end
end

--[[
	Generates the walls and floors of the room, randomizing the various varieties
	of said tiles for visual variety.
]]
function Room:generateWallsAndFloors()
	for y = 1, self.height do
		table.insert(self.tiles, {})

		for x = 1, self.width do
			local id = TILE_EMPTY

			if x == 1 and y == 1 then
				id = TILE_TOP_LEFT_CORNER
			elseif x == 1 and y == self.height then
				id = TILE_BOTTOM_LEFT_CORNER
			elseif x == self.width and y == 1 then
				id = TILE_TOP_RIGHT_CORNER
			elseif x == self.width and y == self.height then
				id = TILE_BOTTOM_RIGHT_CORNER

			-- random left-hand walls, right walls, top, bottom, and floors
			elseif x == 1 then
				id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
			elseif x == self.width then
				id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
			elseif y == 1 then
				id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
			elseif y == self.height then
				id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
			else
				id = TILE_FLOORS[math.random(#TILE_FLOORS)]
			end

			table.insert(self.tiles[y], {
				id = id
			})
		end
	end
end

function Room:update(dt)
	-- don't update anything if we are sliding to another room (we have offsets)
	if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

	self.player:update(dt)

	for i = #self.entities, 1, -1 do
		local entity = self.entities[i]
		if not entity.dead then
			entity:processAI(dt)
		end

		entity:update(dt)

		-- collision between the player and entities in the room
		if not entity.dead and self.player:collides(entity.hitbox)
			and not self.player.invulnerable then

			gSounds['hit-player']:play()
			self.player:damage(1)
			self.player:goInvulnerable(1)

			if self.player.health <= 0 then
				gStateMachine:change('game-over')
			end
		end


		for p, pot in pairs(self.pots) do
			pot:update(dt)
			-- If pot collides with enemy
			if entity:collides(pot) and not entity.dead and not pot.broken then

				entity:damage(1)
				gSounds['hit-enemy']:setVolume(0.6)
				gSounds['hit-enemy']:play()
				pot:breakPot()

			-- If pot hits wall first
		elseif 	pot.x <= MAP_LEFT_EDGE - pot.width or
				pot.x >= MAP_RIGHT_EDGE or
				pot.y <= MAP_TOP_EDGE - 2 - pot.height or
				pot.y  >= MAP_BOTTOM_EDGE then
						pot:breakPot()
			end

            -- if the pot is broken it is removed from the room after 0.5s
            if pot.state == "broken" then
                Timer.after(0.5, function() 
                    table.remove(self.pots, p)
                end)
			end
		end
	end

	for k, object in pairs(self.objects) do

		-- trigger collision callback on object
		if self.player:collides(object) then
			object.onCollide(self.player, object)
			if object.consumed then
				table.remove(self.objects, k)
			end
		end
	end
end



function Room:getRandomCoords()
	local x = math.random(self.width - 2)
	local y = math.random(self.height - 2)

	return MAP_RENDER_OFFSET_X + TILE_SIZE * x, MAP_RENDER_OFFSET_Y + TILE_SIZE * y
end


function Room:render()
	for y = 1, self.height do
		for x = 1, self.width do
			local tile = self.tiles[y][x]
			love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
				(x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX,
				(y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
		end
	end

	-- render doorways; stencils are placed where the arches are after so the player can
	-- move through them convincingly
	for k, doorway in pairs(self.doorways) do
		doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
	end

	for k, object in pairs(self.objects) do
		object:render(self.adjacentOffsetX, self.adjacentOffsetY)
	end

	for k, pot in pairs(self.pots) do
		pot:render(self.adjacentOffsetX, self.adjacentOffsetY)
	end

	for k, entity in pairs(self.entities) do
		entity:render(self.adjacentOffsetX, self.adjacentOffsetY)
	end

	-- stencil out the door arches so it looks like the player is going through
	love.graphics.stencil(function()
		-- left
		love.graphics.rectangle('fill', -TILE_SIZE - 6,
				MAP_RENDER_OFFSET_Y + (self.height / 2) * TILE_SIZE - TILE_SIZE,
				TILE_SIZE * 2 + 6, TILE_SIZE * 2)

		-- right
		love.graphics.rectangle('fill',
				MAP_RENDER_OFFSET_X + (self.width * TILE_SIZE) - 6,
				MAP_RENDER_OFFSET_Y + (self.height / 2) * TILE_SIZE - TILE_SIZE,
				TILE_SIZE * 2 + 6, TILE_SIZE * 2)

		-- top
		love.graphics.rectangle('fill',
				MAP_RENDER_OFFSET_X + (self.width / 2) * TILE_SIZE - TILE_SIZE,
				-TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)

		--bottom
		love.graphics.rectangle('fill',
				MAP_RENDER_OFFSET_X + (self.width / 2) * TILE_SIZE - TILE_SIZE,
				VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
		end, 'replace', 1)

	love.graphics.setStencilTest('less', 1)

	if self.player then
		self.player:render()
	end

	love.graphics.setStencilTest()
	
end