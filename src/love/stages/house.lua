local br, port
return {
    enter = function()
        stageImages = {
            ["bg"] = graphics.newImage(graphics.imagePath("housestage/background")),
        }

        stageImages["bg"].sizeX, stageImages["bg"].sizeY = 2, 2

        br = graphics.newImage(graphics.imagePath("housestage/brasil"))
        port = graphics.newImage(graphics.imagePath("housestage/portugal"))

        br:setGraphicSize(1280, 720)
        port:setGraphicSize(1280, 720)
    end,

    load = function()
        song = song or 1
        br.alpha, port.alpha = 0, 0

        if song == 1 then
            boyfriend = BaseCharacter("sprites/characters/tweak.lua")
            boyfriend.sizeX, boyfriend.sizeY = 2.2, 2.2

            enemy = BaseCharacter("sprites/characters/BoyFriendflow.lua")
            enemy.flipX = true

            enemy.x, enemy.y = -422, 4
            boyfriend.x, boyfriend.y = 130, 12
        end
    end,

    update = function(self, dt)
        if beatHandler.onBeat() then
            local targetRotate = math.rad(beatHandler.getBeat() / 2)
            if beatHandler.getBeat() % 2 == 0 then
                targetRotate = targetRotate * -1
            end

            boyfriendIcon.orientation = targetRotate
            Timer.tween(0.3, boyfriendIcon, {orientation = 0}, "out-quad")

            enemyIcon.orientation = targetRotate
            Timer.tween(0.3, enemyIcon, {orientation = 0}, "out-quad")
        end
    end,

    onEvent = function(self, events)
        for _, event in ipairs(events.events) do
            if event[1] == "flag" then
                if event[2] == "brasil" then
                    br.alpha = 1
                    Timer.tween(1, br, {alpha = 0}, "in-sine")
                elseif event[2] == "portugal" then
                    port.alpha = 1
                    Timer.tween(1, port, {alpha = 0}, "in-sine")
                end
            elseif event[1] == "portugal" then
                
            elseif event[1] == "jumpscare" then
            end
        end
    end,

    draw = function()
		stageImages["bg"]:draw()
		boyfriend:draw()
        enemy:draw()

        br:draw()
        port:draw()
    end,

    leave = function()
        for _, v in pairs(stageImages) do
            v = nil
		end

        graphics.clearCache()
    end
}