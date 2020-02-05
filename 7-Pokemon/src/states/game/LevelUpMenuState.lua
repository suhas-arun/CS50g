-- menu state for when the player's pokemon levels up

LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(def)
    self.newHP = def.HP
    self.newAttack = def.attack
    self.newDefense = def.defense
    self.newSpeed = def.speed

    -- gets the stat increases
    self.HPInc = def.HPInc
    self.attackInc = def.attackInc
    self.defenseInc = def.defenseInc
    self.speedInc = def.speedInc

    -- calculate the previous stats
    self.prevHP = self.newHP - self.HPInc
    self.prevAttack = self.newAttack - self.attackInc
    self.prevDefense = self.newDefense - self.defenseInc
    self.prevSpeed = self.newSpeed - self.speedInc
    
    self.levelUpMenu = Menu {
        x = VIRTUAL_WIDTH - 200,
        y = 0,
        width = 200,
        height = VIRTUAL_HEIGHT - 64,
        cursorEnabled = false,
        items = {
            {
                text = 'HP: ' .. self.prevHP .. ' + ' .. self.HPInc .. ' = ' .. self.newHP,
                
            },
            {
                text = 'Attack: ' .. self.prevAttack .. ' + ' .. self.attackInc .. ' = ' .. self.newAttack,
            },
            {
                text = 'Defense: ' .. self.prevDefense .. ' + ' .. self.defenseInc .. ' = ' .. self.newDefense,
            },
            {
                text = 'Speed: ' .. self.prevSpeed .. ' + ' .. self.speedInc .. ' = ' .. self.newSpeed,
            }
        }
    }
end

function LevelUpMenuState:update(dt)
    self.levelUpMenu:update(dt)
end

function LevelUpMenuState:render()
    self.levelUpMenu:render()
end