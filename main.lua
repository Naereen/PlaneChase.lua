-- PlaneChase : an app to play PlaneChase with your friends
-- See https://mtg.fandom.com/wiki/Planechase_(format)

-- Load assets in the beginning of the game
function love.load()
    -- Load the DejaVuSans font, big size
    font = love.graphics.newFont("DejaVuSans.ttf", 40)
    love.graphics.setFont(font)

    -- Configuration
    love.window.setTitle("Plane Chase for Magic the Gathering ~ By Elliot & Lilian")
    love.graphics.setBackgroundColor(1, 1, 1)
    love.math.setRandomSeed(os.time())

    -- Get all the images in the images/opca-/ directory
    local files = love.filesystem.getDirectoryItems("images/opca-")
    images = {}
    for _, image in ipairs(files) do
        print("Loading", image)
        if isJpg(image) then
            table.insert(images, love.graphics.newImage("images/opca-/" .. image))
        end
    end
    if #images > 0 then
        imageActuelle = getRandomPlaneImage()
    end
    die = "rien"
    dieSize = 0.30

    planeChaseDiceImage = love.graphics.newImage("images/dice/planechase.png")
    chaosDiceImage = love.graphics.newImage("images/dice/chaos.png")
end

-- Update the game, every frame, if needed
function love.update(delta_time)
    -- TODO: maybe we will need a love.update(dt) ?
end

-- Draw the game, for each new frame
function love.draw()
    -- Draw the image of the current plane
    if #images > 0 then
        love.graphics.draw(imageActuelle, love.graphics.getWidth() - 100, 100, math.pi/2)
    end
    -- Print the result of the dice
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Dé :", love.graphics.getWidth()/2 - 60, 30)
    love.graphics.setColor(1, 1, 1)

    if die == "planechase" then
        love.graphics.draw(planeChaseDiceImage, love.graphics.getWidth() / 2 + 20, 10, 0, dieSize, dieSize)
    elseif die == "chaos" then
        love.graphics.draw(chaosDiceImage, love.graphics.getWidth() / 2 + 20, 10, 0, dieSize, dieSize)
    end
end

function love.keypressed(key)
    if key == "escape" then
        print("Exit the app with escape.")
        love.event.quit(0)
    end
    if key == "right" then
        print("Next plane, with right arrow.")
        if #images > 0 then
            imagePrecedente = imageActuelle
            imageActuelle = getRandomPlaneImage()
        end
    end
    if key == "left" then
        -- TODO: this "last plane" feature should use a stack of previously seen planes, not just one!
        print("Last plane, with right arrow.")
        if #images > 0 then
            local tmp = imagePrecedente
            imagePrecedente = imageActuelle
            imageActuelle = tmp
        end
    end
    if key == "space" then
        die = rollChaosDie()
    end
end

-- Tiny fonction, to check if a given filename ends with ".jpg"
function isJpg(filename)
    return string.sub(filename, -4) == ".jpg"
end

-- Go visit a new random plane, possibly the same
-- TODO: improve this! we should NOT be able to go back to a plane we already visisted
function getRandomPlaneImage()
    local new_image = images[love.math.random(1, #images)]
    while new_image == imageActuelle do
        new_image = images[love.math.random(1, #images)]
    end
    return new_image
end

-- Roll the chaos dice
function rollChaosDie()
    local n = love.math.random(6)
    local result = "rien"
    if n == 1 then
        result = "chaos"
    elseif n == 6 then
        result = "planechase"
    end
    print("Planar dice :", result)
    return result
end
