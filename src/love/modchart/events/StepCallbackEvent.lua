local StepCallbackEvent = CallbackEvent:extend()

function StepCallbackEvent:new(step, endStep, callback, modMgr)
    CallbackEvent.new(self, step, callback, modMgr)
    self.endStep = endStep
end

function StepCallbackEvent:run(curStep)
    if (curStep <= self.endStep) then
        self.callback(self, curStep)
    else
        self.finished = true
    end
end

return StepCallbackEvent