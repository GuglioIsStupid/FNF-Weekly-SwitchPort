local bg, border

local newsText1 = {
    x = 1210,
    loopX = 1210,
    text = "BREAKING NEWS!!! BREAKING NEWS!!! "
}
local newsText2 = {
    x = 40,
    loopX = 1210,
    text = "BREAKING NEWS!!! BREAKING NEWS!!! "
}

local function tweenNewsText(text, time)
    Timer.tween(time or 4.25, text, {x = -1000}, "linear", function()
        text.x = text.loopX
        tweenNewsText(text)
    end)
end

local playBTN, optionsBTN, freeplayBTN, marathonBTN, moreBTN
local norbert
local curButton = 1

local curWeek = 1
local weekLogos = {}

local norbertCanIdle = false

local function confirmFunc()
    audio.playSound(selectSound)
    if curButton == 1 then
        status.setLoading(true)
        graphics:fadeOutWipe(
            0.7,
            function()
                Gamestate.switch(menuFreeplay)
                status.setLoading(false)
            end
        )
    elseif curButton == 2 then
    elseif curButton == 3 then
    elseif curButton == 4 then
        status.setLoading(true)
        graphics:fadeOutWipe(
            0.7,
            function()
                Gamestate.switch(menuSettings)
                status.setLoading(false)
            end
        )
    elseif curButton == 5 then
        norbert:animate("start")
        norbert.x = 1000
        music:stop()
        status.setLoading(true)
        graphics:fadeOutWipe(
            0.7,
            function()
                storyMode = true

                Gamestate.switch(weekData[weekNum], 1, "", "")

                status.setLoading(false)
            end
        )
    end
end

DID_THE_FUCKING_TWEENS = false
return {
    enter = function()
        bg = graphics.newImage(graphics.imagePath("tweakmenu/bg"))
        bg.x, bg.y = graphics.getWidth()/2, graphics.getHeight()/2

        border = graphics.newImage(graphics.imagePath("tweakmenu/border"))
        border.x, border.y = graphics.getWidth()/2, graphics.getHeight()/2

        playBTN = love.filesystem.load("sprites/tweakmenu/button_play.lua")()
        playBTN.x, playBTN.y = graphics.getWidth()-93, graphics.getHeight()-90

        optionsBTN = love.filesystem.load("sprites/tweakmenu/button_options.lua")()
        optionsBTN.x, optionsBTN.y = 55, graphics.getHeight()-50

        freeplayBTN = love.filesystem.load("sprites/tweakmenu/button_freeplay.lua")()
        freeplayBTN.x, freeplayBTN.y = 165, 85

        marathonBTN = love.filesystem.load("sprites/tweakmenu/button_marathon.lua")()
        marathonBTN.x, marathonBTN.y = 425, 85
        marathonBTN.alpha = 0.5

        moreBTN = love.filesystem.load("sprites/tweakmenu/button_more.lua")()
        moreBTN.x, moreBTN.y = 685, 85
        moreBTN.alpha = 0.5

        norbert = love.filesystem.load("sprites/tweakmenu/norbert.lua")()

        norbert:animate("intro")
        norbert.y = 420
        norbert.x = 525
        norbert.visible = false
        norbertCanIdle = false
        Timer.after(0.5, function()
            norbert.visible = true
            norbert:animate("intro", false, function()
                norbert.x = 1000
                norbertCanIdle = true
            end)
            norbert.y = 420
            norbert.x = 525
        end)

        graphics:fadeInWipe(0.5)

        if not DID_THE_FUCKING_TWEENS then
            tweenNewsText(newsText1)
            tweenNewsText(newsText2, 2.05)

            DID_THE_FUCKING_TWEENS = true
        end

        weekLogos[1] = graphics.newImage(graphics.imagePath("weeklogos/tweakingboss"))

        for _, logo in ipairs(weekLogos) do
            logo.x, logo.y = 420, 315
        end
    end,

    update = function(self, dt)
        playBTN:update(dt)
        optionsBTN:update(dt)
        freeplayBTN:update(dt)
        marathonBTN:update(dt)
        moreBTN:update(dt)
        norbert:update(dt)

        if input:pressed("right") then
            curButton = curButton + 1
            if curButton > 5 then
                curButton = 1
            end
        elseif input:pressed("left") then
            curButton = curButton - 1
            if curButton < 1 then
                curButton = 5
            end
        elseif input:pressed("confirm") then
            confirmFunc()
        end
        
        playBTN:animate("play")
        optionsBTN:animate("options")
        freeplayBTN:animate("freeplay")
        marathonBTN:animate("marathon")
        moreBTN:animate("more")

        if curButton == 1 then
            freeplayBTN:animate("freeplay hover")
        elseif curButton == 2 then
            marathonBTN:animate("marathon hover")
        elseif curButton == 3 then
            moreBTN:animate("more hover")
        elseif curButton == 4 then
            optionsBTN:animate("options hover")
        elseif curButton == 5 then
            playBTN:animate("play hover")
        end

        beatHandler.update(dt)

        if beatHandler.onBeat() and norbertCanIdle and not graphics.isFading() then
            norbert.x = 1000
            norbert:animate("idle")
        end
    end,

    mousemoved = function(self, x, y, dx, dy, istouch)
        local x, y = push.toGame(x, y)

        if x >= (freeplayBTN.x - freeplayBTN:getFrameWidth()/2) and x <= (freeplayBTN.x + freeplayBTN:getFrameWidth()/2) 
            and y >= (freeplayBTN.y - freeplayBTN:getFrameHeight()/2) and y <= (freeplayBTN.y + freeplayBTN:getFrameHeight()/2) then
                curButton = 1
        elseif x >= (optionsBTN.x - optionsBTN:getFrameWidth()/2) and x <= (optionsBTN.x + optionsBTN:getFrameWidth()/2) 
            and y >= (optionsBTN.y - optionsBTN:getFrameHeight()/2) and y <= (optionsBTN.y + optionsBTN:getFrameHeight()/2) then
                curButton = 4
        elseif x >= (playBTN.x - playBTN:getFrameWidth()/2) and x <= (playBTN.x + playBTN:getFrameWidth()/2) 
            and y >= (playBTN.y - playBTN:getFrameHeight()/2) and y <= (playBTN.y + playBTN:getFrameHeight()/2) then
                curButton = 5
        else
            curButton = 0
        end
    end,

    mousepressed = function(self)
        confirmFunc()
    end,

    draw = function(self)
        local lastFont = love.graphics.getFont()
        love.graphics.push()
            bg:draw()
            border:draw()

            love.graphics.setFont(lastFont)
            love.graphics.print("TRACK LIST:     " .. weekMeta[curWeek][1], 870, 60, 0, 1.1, 1.1)
            for i, song in ipairs(weekMeta[curWeek][2]) do
                love.graphics.print(song, 870, 60 + 22 * i, 0, 1.1, 1.1)
            end

            weekLogos[curWeek]:draw()

            norbert:draw()

            graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", 0, 550, graphics.getWidth(), 150)
            graphics.setColor(1, 1, 1)

            love.graphics.push()
                love.graphics.setFont(newsFont)
                love.graphics.print(newsText1.text, newsText1.x, 562, 0, 0.9, 0.9)
                love.graphics.print(newsText2.text, newsText2.x, 562, 0, 0.9, 0.9)
            love.graphics.pop()

            playBTN:draw()
            optionsBTN:draw()
            freeplayBTN:draw()
            marathonBTN:draw()
            moreBTN:draw()
        love.graphics.pop()
    end
}