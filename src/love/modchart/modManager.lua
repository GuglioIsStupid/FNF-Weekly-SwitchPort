local modManager = Object:extend()

EventTimeline = require "modchart.EventTimeline"

-- EVENTS
BaseEvent = require "modchart.events.BaseEvent"
ModEvent = require "modchart.events.ModEvent"
EaseEvent = require "modchart.events.EaseEvent"
SetEvent = require "modchart.events.SetEvent"

CallbackEvent = require "modchart.events.CallbackEvent"
StepCallbackEvent = require "modchart.events.StepCallbackEvent"

-- MODIFIERS
Modifier = require "modchart.Modifier"
SubModifier = require "modchart.SubModifier"
NoteModifier = require "modchart.NoteModifier"

OpponentModifier = require "modchart.modifiers.OpponentModifier"
TransformModifier = require "modchart.modifiers.TransformModifier"

function modManager:registerDefaultModifiers()
    self.timeline = EventTimeline()
    self.notemodRegisters = {}
    self.miscmodManagers = {}

    self.register = {}

    self.modArray = {}
    self.activeMods = {{}, {}}

    local quickRegs = {
        OpponentModifier,
        TransformModifier
    }

    for _, mod in ipairs(quickRegs) do
        self:quickRegister(mod(self))
    end

    --[[ 
    self:quickRegister(RotateModifier(self))
    self:quickRegister(RotateModifier(self, "center", {x = (push:getWidth()/2) - (150/2), y = (push:getHeight()/2) - (150/2), z = 0}))
    self:quickRegister(LocalRotateModifier(self, "local"))
    ]]

    --[[ self:quickRegister(SubModifier("noteSpawnTime", self))
    self:setValue("noteSpawnTime", 2000)  ]]

    --[[ self:setValue("xmod", 1)
    for i = 1, 4 do
        self:setValue("xmod" .. i, 1)
    end ]]
end

modManager.receptors = {}
modManager.timeline = EventTimeline()
modManager.notemodRegisters = {}
modManager.miscmodManagers = {}

modManager.register = {}

modManager.modArray = {}
modManager.activeMods = {{}, {}}

function modManager:quickRegister(mod)
    self:registerMod(mod:getName(), mod)
end

function modManager:registerMod(modName, mod, registerSubmods)
    local registerSubmods = (registerSubmods == nil and true) or false

    self.register[modName] = mod

    local switch = mod:getModType()
    if switch == "NOTE_MOD" then
        self.notemodRegisters[modName] = mod
    elseif switch == "MISC_MOD" then
        self.miscmodManagers[modName] = mod
    end

    self.timeline:addMod(modName)
    table.insert(self.modArray, mod)

    if registerSubmods then
        for _, submod in pairs(mod.submods) do
            self:quickRegister(submod)
        end
    end

    self:setValue(modName, 0)

    table.sort(self.modArray, function(a, b)
        return a:getOrder() < b:getOrder()
    end)
end

function modManager:get(modName)
    return self.register[modName]
end

function modManager:getPercent(modName, player)
    return self.register[modName]:getPercent(player)
end

function modManager:getValue(modName, player)
    return self.register[modName]:getValue(player)
end

function modManager:setPercent(modName, val, player)
    local player = player or -1
    self:setValue(modName, val/100, player)
end

function modManager:setValue(modName, val, player)
    local player = player or -1
    if player == -1 then
        for i = 1, 2 do
            self:setValue(modName, val, i)
        end
    else
        local daMod = self.register[modName]
        local mod = daMod.parent == nil and daMod or daMod.parent

        local name = mod:getName()

        if self.activeMods[player] == nil then
            self.activeMods[player] = {}
        end

        self.register[modName]:setValue(val, player)

        if not table.contains(self.activeMods[player], name) and mod:shouldExecute(player, val) then
            if daMod:getName() ~= name then
                table.insert(self.activeMods[player], daMod:getName())
            end
            table.insert(self.activeMods[player], name)
        elseif not mod:shouldExecute(player, val) then
            local modParent = daMod.parent
            if modParent == nil then
                for name, mod in pairs(daMod.submods) do
                    modParent = daMod
                    break
                end
            end
            if daMod ~= modParent then
                local id = table.find(self.activeMods[player], daMod:getName())
                table.remove(self.activeMods[player], id)
            end

            if modParent ~= nil then
                if modParent:shouldExecute(player, modParent:getValue(player)) then
                    table.sort(self.activeMods[player], function(a, b)
                        return self.register[a]:getOrder() < self.register[b]:getOrder()
                    end)
    
                    return
                end

                for subname, submod in pairs(modParent.submods) do
                    if submod:shouldExecute(player, submod:getValue(player)) then
                        table.sort(self.activeMods[player], function(a, b)
                            return self.register[a]:getOrder() < self.register[b]:getOrder()
                        end)
                        return
                    end
                end

                local id = table.find(self.activeMods[player], modParent:getName())
                table.remove(self.activeMods[player], id)
            else
                local id = table.find(self.activeMods[player], daMod:getName())
                table.remove(self.activeMods[player], id)
            end

            table.sort(self.activeMods[player], function(a, b)
                return self.register[a]:getOrder() < self.register[b]:getOrder()
            end)
        end
    end
end

function modManager:update(dt)
    for _, mod in ipairs(self.modArray) do
		if mod.active and mod:doesUpdate() then
			mod:update(dt)
		end
	end
end

function modManager:updateTimeline(step)
    self.timeline:update(step)
end

function modManager:getBaseX(direction, player)
    local x = 0
    if player == 2 then
        x = -925 + 165 * direction
    elseif player == 1 then
        x = 100 + 165 * direction
    end

    return x
end

function modManager:updateStrum(beat, strum, pos, player)
    for i, name in ipairs(self.activeMods[player]) do
        local mod = self.notemodRegisters[name]
        if mod == nil then goto continue end
        mod:updateReceptor(beat, strum, pos, player)

        ::continue::
    end
end

function modManager:updateNote(beat, note, pos, player)
    for i, name in ipairs(self.activeMods[player]) do
        local mod = self.notemodRegisters[name]
        if mod == nil then goto continue end
        mod:updateNote(beat, note, pos, player)

        ::continue::
    end
end

function modManager:getBaseVisPosD(diff, songSpeed)
    local songSpeed = songSpeed or 1
    return (0.45 * diff * songSpeed)
end

function modManager:getVisPos(songPos, strumTime, songSpeed)
    local songPos = songPos or 0 
    local strumTime = strumTime or 0
    local songSpeed = songSpeed or 1
    return -self:getBaseVisPosD(songPos - strumTime, songSpeed)
end

function modManager:getPos(time, diff, tDiff, beat, data, player, obj, exclusions, pos)
    if exclusions == nil then exclusions = {} end
    if pos == nil then pos = {x = 0, y = 0, z = 0} end

    pos.x = self:getBaseX(data, player)
    pos.y = CONSTANTS.WEEKS.STRUM_Y + diff
    pos.z = 0

    for _, name in ipairs(self.activeMods[player]) do
        if exclusions[name] then
            goto continue
        end
        
        local mod = self.notemodRegisters[name]
        if not mod then
            goto continue
        end

        pos = mod:getPos(time, diff, tDiff, beat, pos, data, player, obj)

        ::continue::
    end
    
    return pos
end

function modManager:queueEaseP(step, endStep, modName, percent, style, player, startVal)
    local style = style or 'linear'
    local player = player or -1
    local startVal = startVal or 0

    local decimalPercent = percent * 0.01
    local decimalStartVal = startVal * 0.01

    self:queueEase(step, endStep, modName, decimalPercent, style, player, decimalStartVal)
end

function modManager:queueSetP(step, modName, percent, player)
    local player = player or -1
    self:queueSet(step, modName, percent * 0.01, player)
end

function modManager:queueEase(step, endStep, modName, target, style, player, startVal)
    if player == -1 then
        self:queueEase(step, endStep, modName, target, style, 1)
        self:queueEase(step, endStep, modName, target, style, 2)
    else
        local ease = linear
        
        local newEase = _G[style]
        if newEase and type(newEase) == "function" then
            ease = newEase
        end

        self.timeline:addEvent(EaseEvent(step, endStep, modName, target, ease, player, self))
    end
end

function modManager:queueSet(step, modName, target, player)
    if player == -1 then
        self:queueSet(step, modName, target, 1)
        self:queueSet(step, modName, target, 2)
    else
        self.timeline:addEvent(SetEvent(step, modName, target, player, self))
    end
end

function modManager:queueFunc(step, endStep, callback)
    self.timeline:addEvent(StepCallbackEvent(step, endStep, callback, self))
end

function modManager:queueFuncOnce(step, callback)
    self.timeline:addEvent(CallbackEvent(step, callback, self))
end

return modManager