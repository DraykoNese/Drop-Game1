if arg[2] == "debug" then
    require("lldebugger").start()
end

--Game where multiple images fall from sky  
--User clicks to send them back to top
--Click images before they hit the bottom or game over


--should have title screen, level 1, game over
function titleload()
    blueSquare = love.graphics.newImage("blue_body_square.png")
   titleText = "Square Drop"
    --Update the window to be titled the titleText
love.window.setTitle(titleText)
end 

--Set up draw for the title WARNING, THIS IS HARDCODED FOR 800x600
function titleDraw()
    --create text at 100 pts
    love.graphics.setFont(love.graphics.newFont(100))
    --formatted text print
    love.graphics.printf(titleText, 0, 200, love.graphics.getWidth(), "center")

    --create a button
    love.graphics.setColor(1,1,1)
    --type, x, y, wiodth, height, cornerx, cornery, segments
    --this is hardcoded to be a button on the left half of a 800x600 screen
    love.graphics.rectangle("fill", 50, 450, 250, 100, 10, 10, 6)
    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(love.graphics.newFont(75))
    love.graphics.printf("PLAY", 50, 450, 250, "center")
    love.graphics.setColor(1,1,1) --reset color back to white so it doesn't bleed
end

--Create randomized table of stars
function randomizeStars()
    math.randomseed(os.time())
    math.random(); math.random(); math.random()

    count = 100 --number of stars we want on our canvas
    stars = {} --this is the table of x, y values for our stars
    while count > 0 do
        stars[#stars+1] = math.random(0, love.graphics.getWidth()) --get random x value
        stars[#stars+1] = math.random(0, love.graphics.getHeight()) --get randon y value
        count = count - 1
    end
    return stars
end


--take a parameter of a table of x and y points and draw stars
function drawStars(stars)
    --starglow (big brush, light opacity)
    love.graphics.setColor(math.random(), math.random(), math.random(), .22)
    love.graphics.setPointSize(10)
    love.graphics.points(stars)
    
    --center (small brush, high opacity)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setPointSize(2)
    love.graphics.points(stars)
end
-----------------------------------------------------------------
---LOAD ALL THINGS
---
-----------------------------------------------------------------
    function love.load()
        
    --by default, Love sets window to 500x600
    success =  love.window.updateMode(800, 600)
starsTable = randomizeStars() --this creates our randomized table of stars
    --load title screen


    titleload()

--0 = title screen
--1 = game screen
--2 = game over screen
    scene = 0
    

    --set up obstacles at bottom
        spikes = love.graphics.newImage("tile_background_tree_small.png")

    --set up square variables
    squareP = love.graphics.newImage("purple_body_square.png")
    squareNums = 5 --how many squares
    squareX = {} --where at (x)
    squareY = {} --where at (y)
    squareSpeed = {} --how fast
    minSpeed = 10
    maxSpeed = 20  
    speedMod = 1
    count = squareNums

--Randomization
 math.randomseed(os.time())
    math.random(); math.random(); math.random()

    --initially populate the square
    while count > 0 do
        --get an x value between 0 and width of screen minus width of square 
        squareX[#squareX+1] = math.random(0, love.graphics.getWidth() - squareP:getWidth())
        -- get a random y value between 1 and 2 squares above window
        squareY[#squareY+1] = 0 -- math.random(squareP:getHeight(), squareP:getHeight()*2)
        -- get a random speed between min and max 
        squareSpeed[#squareSpeed+1] = math.random(minSpeed, maxSpeed)
        count = count - 1 --count down
    end
 speedUpTimer = 0    -- counts down to next speed-up
    speedUpIntervalMin = 1    -- minimum seconds between speed-ups
    speedUpIntervalMax = 3    -- maximum seconds between speed-ups
    speedUpTimer = math.random(speedUpIntervalMin * 100, speedUpIntervalMax * 100) / 100
    

 speedUpTimer = math.random(speedUpIntervalMin * 100, speedUpIntervalMax * 100) / 100
 -- Update speedUpTimer
        speedUpTimer = speedUpTimer - 0
        if speedUpTimer <= 0 then
            -- Pick a random square to speed up
            local index = math.random(1, #squareSpeed)
            -- Increase speed randomly, e.g. by between 5 and 20 units
            local speedIncrement = math.random(5, 20)
            squareSpeed[index] = squareSpeed[index] + speedIncrement
            print("Square " .. index .. " sped up by " .. speedIncrement .. ", now speed: " .. squareSpeed[index])
               
            -- Reset the timer for next speed-up
    

        end
    if scene == 1 then
    if speedUpTimer <= 0 then
     love.graphics.printf("A square gets Faster...",  450, 250, "left")
    end
    end
end
------------------------------------------------------------------
--- CLICK ALL THINGS
---
------------------------------------------------------------------
function love.mousepressed(x, y, button, istouch)
    --if it's left click
    if button == 1 then
            --if on title screen
            if scene == 0 then
                --if title screen
                --click play button
                --HARDCODED
                if x >= 50 and x <= 300 and y >= 450 and y <= 550 then
                    scene = 1
                end
            end
            --in game
          if scene == 1 then
            --check EACH image and see if it has collided with the mouse click
            for i, value in ipairs(squareX) do
            if x >= squareX[i] and x <= squareX[i] + squareP:getWidth() and y >= squareY[i] and y <= squareY[i] + squareP:getHeight() then
                print("hit in the x")
                --randomize
                math.randomseed(os.time())
                math.random(); math.random(); math.random()
                --send back to top and change the speed
                speedMod = speedMod + 1
                maxSpeed = maxSpeed + speedMod
                squareX[i] = math.random(0, love.graphics.getWidth() - squareP:getWidth())
                squareY[i] = 0 - math.random(squareP:getHeight(), squareP:getHeight() * 2)
                squareSpeed[i] = math.random(squareSpeed[i], maxSpeed) --can only get faster
                break --so that it only clicks ONE thing and not overlapping things
            end
            end
    end
end
end


------------------------------------------------------------------
--- UPDATE ALL THINGS
---
------------------------------------------------------------------
function love.update(dt)
    if scene == 1 then
        -- Move squares down
        for i, value in ipairs(squareX) do
            if squareY[i] + squareP:getHeight() >= love.graphics.getHeight() - spikes:getHeight() / 2 then
                print("Over The Edge")
                love.event.quit("restart")
            end
            squareY[i] = squareY[i] + squareSpeed[i] * dt
        end

        -- Update speedUpTimer
        speedUpTimer = speedUpTimer - dt
        if speedUpTimer <= 0 then
            -- Pick a random square to speed up
            local index = math.random(1, #squareSpeed)
            -- Increase speed randomly, e.g. by between 5 and 20 units
            local speedIncrement = math.random(5, 20)
            squareSpeed[index] = squareSpeed[index] + speedIncrement
          
            
            -- Reset the timer for next speed-up
            speedUpTimer = math.random(speedUpIntervalMin * 100, speedUpIntervalMax * 100) / 100
        end
    end

   
   
end
------------------------------------------------------------------
---DRAW THINGS
---
------------------------------------------------------------------
function love.draw()
    drawStars(starsTable)
    --TITLE SCREEN
    if scene == 0 then
        --draw title screen
        titleDraw()
    end
    --GAMEPLAY
    if scene == 1 then
        --Draw spikes across the bottm of the screen
        for x = 0, love.graphics.getWidth(),spikes:getWidth() do
        love.graphics.draw(spikes, x, love.graphics.getHeight() - spikes:getHeight())
        end
        for i, value in ipairs(squareX) do
            love.graphics.draw(squareP, squareX[i], squareY[i]) 
        end
    end
    
    if scene == 2 then
         --draw game over screen
    end
    
end











local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end