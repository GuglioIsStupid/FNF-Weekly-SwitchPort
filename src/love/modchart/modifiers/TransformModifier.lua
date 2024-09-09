local TransformModifier = NoteModifier:extend()

function TransformModifier:lerp(a, b, c)
    return a + (b - a) * c
end

function TransformModifier:getName()
    return "transformX"
end

function TransformModifier:getOrder()
    return MODIFIER_ORDER.LAST
end

function TransformModifier:getPos(time, visualDiff, timeDiff, beat, pos, data, player, obj)
    pos.x = pos.x + self:getValue(player) + self:getSubmodValue("transformX-a", player)

    pos.y = pos.y + self:getSubmodValue("transformY", player) + self:getSubmodValue("transformY-a", player)
    pos.z = pos.z + self:getSubmodValue('transformZ', player) + self:getSubmodValue("transformZ-a", player)
    
    pos.x = pos.x + self:getSubmodValue(string.format('transform%dX', data), player) + self:getSubmodValue(string.format('transform%dX-a', data), player)
    pos.y = pos.y + self:getSubmodValue(string.format('transform%dY', data), player) + self:getSubmodValue(string.format('transform%dY-a', data), player)
    pos.z = pos.z + self:getSubmodValue(string.format('transform%dZ', data), player) + self:getSubmodValue(string.format('transform%dZ-a', data), player)
    
    return pos
end

function TransformModifier:getSubmods()
    local subMods = {"transformY", "transformZ", "transformX-a", "transformY-a", "transformZ-a"}
    
    for i = 1, 4 do
        table.insert(subMods, string.format('transform%dX', i))
        table.insert(subMods, string.format('transform%dY', i))
        table.insert(subMods, string.format('transform%dZ', i))
        table.insert(subMods, string.format('transform%dX-a', i))
        table.insert(subMods, string.format('transform%dY-a', i))
        table.insert(subMods, string.format('transform%dZ-a', i))
    end
    return subMods
end

return TransformModifier