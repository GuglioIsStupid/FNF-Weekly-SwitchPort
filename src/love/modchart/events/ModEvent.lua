local ModEvent = BaseEvent:extend()

function ModEvent:new(step, modName, target, player, modMgr)
    local player = player or -1
    BaseEvent.new(self, step, modMgr)
    
    self.modName = modName
    self.player = player
    self.endVal = target
    self.mod = modMgr:get(modName)
end

return ModEvent