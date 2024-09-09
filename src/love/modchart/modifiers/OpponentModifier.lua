local OpponentModifier = NoteModifier:extend()

function OpponentModifier:getName()
    return 'opponentSwap'
end

function OpponentModifier:getPos(time, diff, tDiff, beat, pos, data, player, obj)
    if self:getValue(player) == 0 then
        return pos
    end

    local nPlayer = player == 1 and 2 or 1

    local oppX = self.modMgr:getBaseX(data, nPlayer)
    local plrX = self.modMgr:getBaseX(data, player)

    local distX = oppX - plrX

    pos.x = pos.x + distX * self:getValue(player)

    return pos
end

return OpponentModifier