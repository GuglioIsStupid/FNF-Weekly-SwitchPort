local SubModifier = Modifier:extend()

function SubModifier:new(name, modMgr, parent)
    Modifier.new(self, modMgr, parent)
    self.name = name or "unspecified"
end

function SubModifier:getName()
    return self.name
end

function SubModifier:getOrder()
    return MODIFIER_ORDER.LAST
end

function SubModifier:doesUpdate()
    return false
end

return SubModifier