local EaseEvent = ModEvent:extend()

function EaseEvent:new(step, endStep, modName, target, easeFunc, player, modMgr, startVal)
    local player = player or 1
    ModEvent.new(self, step, modName, target, player, modMgr)
    self.endStep = endStep
    self.easeFunc = easeFunc
    self.startVal = startVal
    
    self.length = self.endStep - self.step
end

function EaseEvent:ease(e, t, b, c, d)
    local time = t / d
    return c * e(time) + b
end

function EaseEvent:run(curStep)
    if curStep <= self.endStep then
        if self.startVal == nil then
            self.startVal = self.mod:getValue(self.player)
        end

        local passed = curStep - self.executionStep
        local change = self.endVal - self.startVal

        self.manager:setValue(self.modName, self:ease(self.easeFunc, passed, self.startVal, change, self.length), self.player)
    elseif curStep > self.endStep then
        self.finished = true
        self.manager:setValue(self.modName, self.endVal, self.player)
    end
end

return EaseEvent