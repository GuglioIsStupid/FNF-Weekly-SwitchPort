local BaseEvent = Object:extend()

function BaseEvent:new(step, manager)
    self.manager = manager
    self.executionStep = step
    self.ignoreExecution = false
    self.finished = false
end

function BaseEvent:run() end

return BaseEvent