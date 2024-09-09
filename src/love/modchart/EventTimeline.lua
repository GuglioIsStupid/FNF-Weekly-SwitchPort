local EventTimeline = Object:extend()

function EventTimeline:new()
    self.modEvents = {} -- A table to hold mod events
    self.events = {} -- A table to hold base events
end

function EventTimeline:addMod(modName)
    if not self.modEvents[modName] then
        self.modEvents[modName] = {}
    end
end

function EventTimeline:addEvent(event)
    if event:is(ModEvent) then
        local modEvent = event
        local name = modEvent.modName
        if not self.modEvents[name] then
            self:addMod(name)
        end

        if not self:contains(self.modEvents[name], modEvent) then
            table.insert(self.modEvents[name], modEvent)
        end

        table.sort(self.modEvents[name], function(a, b)
            return a.executionStep < b.executionStep
        end)
    else
        if not self:contains(self.events, event) then
            table.insert(self.events, event)
        end

        table.sort(self.events, function(a, b)
            return a.executionStep < b.executionStep
        end)
    end
end

function EventTimeline:update(step)
    for modName, schedule in pairs(self.modEvents) do
        local garbage = {}
        for _, event in ipairs(schedule) do
            if event.finished then
                table.insert(garbage, event)
            end

            if event.ignoreExecution or event.finished then
                goto continue
            end

            if step >= event.executionStep then
                event:run(step)
            else
                break
            end

            if event.finished then
                table.insert(garbage, event)
            end

            ::continue::
        end

        for _, trash in ipairs(garbage) do
            self:remove(schedule, trash)
        end
    end

    local garbage = {}
    for _, event in ipairs(self.events) do
        if event.finished then
            table.insert(garbage, event)
        end

        if event.ignoreExecution or event.finished then
            goto continue
        end

        if step >= event.executionStep then
            event:run(step)
        else
            break
        end

        if event.finished then
            table.insert(garbage, event)
        end

        ::continue::
    end

    for _, trash in ipairs(garbage) do
        self:remove(self.events, trash)
    end
end

function EventTimeline:contains(table, item)
    for _, value in ipairs(table) do
        if value == item then
            return true
        end
    end
    return false
end

function EventTimeline:remove(table, item)
    for i, value in ipairs(table) do
        if value == item then
            table.remove(table, i)
            break
        end
    end
end

return EventTimeline