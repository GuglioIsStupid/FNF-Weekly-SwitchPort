local SetEvent = ModEvent:extend()

function SetEvent:run(curStep)
    self.manager:setValue(self.modName, self.endVal, self.player)
    self.finished = true
end

return SetEvent