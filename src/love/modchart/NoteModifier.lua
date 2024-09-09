local NoteModifier = Modifier:extend()

function NoteModifier:getModType()
    return "NOTE_MOD"
end

return NoteModifier