local CallbackEvent = BaseEvent:extend()

function CallbackEvent:new(step, callback, modMgr)
    BaseEvent.new(self, step, modMgr)
    self.callback = callback
end

function CallbackEvent:run(curStep)
    self.callback(self, curStep)
    self.finished = true
end

return CallbackEvent