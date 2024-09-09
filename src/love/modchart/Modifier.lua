MODIFIER_ORDER = {
    FIRST = -1000,
    PRE_REVERSE = -3,
    REVERSE = -2,
    POST_REVERSE = -1,
    DEFAULT = 0,
    LAST = 1000
}

local Modifier = Object:extend()

function Modifier:new(modMgr, parent)
    self.modMgr = modMgr
    self.parent = parent or nil
    self.percents = {0, 0}
    self.submods = {}
    self.active = false -- used for performance reasons
    for _, submodName in ipairs(self:getSubmods()) do
        print(submodName)
        self.submods[submodName] = SubModifier(submodName, modMgr, self)
    end
end

function Modifier:getModType()
    return "MISC_MOD"
end

function Modifier:ignorePos()
    return false
end

function Modifier:ignoreUpdateReceptor()
    return true
end

function Modifier:ignoreUpdateNote()
    return true
end

function Modifier:doesUpdate()
    return self:getModType() == "MISC_MOD"
end

function Modifier:shouldExecute(player, value)
    return value ~= 0
end

function Modifier:getOrder()
    return MODIFIER_ORDER.DEFAULT
end

function Modifier:getName()
    error("NotImplementedException: Override in your modifier!")
end

-- Get the value for a player
function Modifier:getValue(player)
    return self.percents[player]
end

-- Get the percent fo a player
function Modifier:getPercent(player)
    return self:getValue(player) * 100
end

function Modifier:setValue(value, player)
    if player == -1 then
        for i = 1, #self.percents do
            self.percents[i] = value
        end
    else
        self.percents[player] = value
    end
end

function Modifier:setPercent(percent, player)
    self:setValue(percent * 0.01, player)
end

function Modifier:getSubmods()
    return {}
end

function Modifier:getSubmodPercent(modName, player)
    local submod = self.submods[modName]
    if submod then
        return submod:getPercent(player)
    else
        return 0
    end
end

function Modifier:getSubmodValue(modName, player)
    local submod = self.submods[modName]
    if submod then
        return submod:getValue(player)
    else
        return 0
    end
end

function Modifier:setSubmodPercent(modName, endPercent, player)
    local submod = self.submods[modName]
    if submod then
        submod:setPercent(endPercent, player)
    end
end

function Modifier:setSubmodValue(modName, endValue, player)
    local submod = self.submods[modName]
    if submod then
        submod:setValue(endValue, player)
    end
end

function Modifier:updateReceptor(beat, receptor, pos, player)
end

function Modifier:updateNote(beat, note, pos, player)
end

-- Get the position (to be overridden)
function Modifier:getPos(time, diff, tDiff, beat, pos, data, player, obj)
    return pos 
end

function Modifier:update(elapsed)
end

return Modifier