local function middleshit(self, mid)
    if mid then
        self.tik.alpha = 1
        self.bar.alpha = 1
        hideUI = true
    else
        self.tik.alpha = 0
        self.bar.alpha = 0
        hideUI = false
    end
end

return {
    enter = function(self)
        stageImages = {
            ["bg"] = graphics.newImage(graphics.imagePath("housestage/background")),
        }

        stageImages["bg"].sizeX, stageImages["bg"].sizeY = 2, 2

        self.br = graphics.newImage(graphics.imagePath("housestage/brasil"))
        self.port = graphics.newImage(graphics.imagePath("housestage/portugal"))
        self.jumpscare = graphics.newImage(graphics.imagePath("housestage/jumpscare!"))
        self.baby = graphics.newImage(graphics.imagePath("housestage/baby"))

        self.bar = graphics.newImage(graphics.imagePath("housestage/YALLGONNAHATEMEFORTHIS"))
        self.tik = graphics.newImage(graphics.imagePath("housestage/sussyfunk"))
        self.pee = graphics.newImage(graphics.imagePath("housestage/fuck"))
        self.bee = graphics.newImage(graphics.imagePath("housestage/quote"))

        self.tik.x, self.tik.y = 683 - self.tik:getWidth()/2, 655 - self.tik:getHeight()/2

        self.bar.alpha = 0
        self.tik.alpha = 0
        self.pee.alpha = 0
        self.bee.alpha = 0

        self.pee:setGraphicSize(1280, 720)
        self.bee:setGraphicSize(1280, 720)

        self.br:setGraphicSize(1280, 720)
        self.port:setGraphicSize(1280, 720)
        self.jumpscare:setGraphicSize(1280, 720)

        self.curCaption = ""

        self.baby.visible = false
    end,

    load = function(self)
        self.br.alpha, self.port.alpha = 0, 0
        self.jumpscare.visible = false
        self.bar.alpha = 0
        self.tik.alpha = 0
        self.pee.alpha = 0
        self.bee.alpha = 0
        self.curCaption = ""

        self.baby.visible = false

        if song == 1 then
            boyfriend = BaseCharacter("sprites/characters/tweak.lua")
            boyfriend.sizeX, boyfriend.sizeY = 2.2, 2.2

            enemy = BaseCharacter("sprites/characters/BoyFriendflow.lua")
            enemy.flipX = true

            enemy.x, enemy.y = -422, 4
            boyfriend.x, boyfriend.y = 130, 12
        else
            boyfriend = BaseCharacter("sprites/characters/BoyFriendflow.lua")
            enemy = BaseCharacter("sprites/characters/tweak.lua")
            enemy.sizeX, enemy.sizeY = 2.2, 2.2
            enemy.x, enemy.y = -517, -41

            boyfriend.x, boyfriend.y = 175, 75
            self.baby.x, self.baby.y = 175, 75
        end
    end,

    update = function(self, dt)
        if beatHandler.onBeat() then
            if not boyfriendIcon then return end
            local beat = beatHandler.beat
            local targetRotate = math.rad(beat / 2)
            if beat % 2 == 0 then
                targetRotate = targetRotate * -1
            end

            boyfriendIcon.orientation = targetRotate
            Timer.tween(0.3, boyfriendIcon, {orientation = 0}, "out-quad")

            enemyIcon.orientation = targetRotate
            Timer.tween(0.3, enemyIcon, {orientation = 0}, "out-quad")
        end

        if beatHandler.onStep() then
            local step = beatHandler.curStep

            if song == 2 then
                if step == 160 then
                    middleshit(self, true)
                elseif step == 216 then
                    middleshit(self, false)
                elseif step == 560 then
                    self.pee.alpha = 1
                elseif step == 574 then
                    Timer.tween(2, self.bee, {alpha = 1})
                end
            end
        end
    end,

    onEvent = function(self, events)
        for _, event in ipairs(events.events) do
            if event[1] == "flag" then
                if event[2] == "brasil" then
                    self.br.alpha = 1
                    Timer.tween(1, self.br, {alpha = 0}, "in-sine")
                elseif event[2] == "portugal" then
                    self.port.alpha = 1
                    Timer.tween(1, self.port, {alpha = 0}, "in-sine")
                end        
            elseif event[1] == "jumpscare" then
                print(event[2])
                if event[2] == "on" then
                    self.jumpscare.visible = true
                else
                    self.jumpscare.visible = false
                end
            elseif event[1] == "caption" then
                self.curCaption = event[2]
            elseif event[1] == "baby" then
                self.baby.visible = true
                boyfriend.visible = false
            elseif event[1] == "baby2" then
                self.baby.visible = true
                boyfriend.visible = false
            end
        end
    end,

    draw = function(self)
		stageImages["bg"]:draw()
		boyfriend:draw()
        self.baby:draw()
        enemy:draw()
    end,

    leave = function()
        for _, v in pairs(stageImages) do
            v = nil
		end

        graphics.clearCache()
    end
}