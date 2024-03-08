function love.load ()
    love.window.setMode(1000, 768)
    
    anim8 = require 'libraries/anim8/anim8';
    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'

    cam = cameraFile()

    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png');

    local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight());
    
    animations = {}
    animations.idle = anim8.newAnimation(grid('1-15',1), 0.05);
    animations.jump = anim8.newAnimation(grid('2-7',2), 0.05);
    animations.run = anim8.newAnimation(grid('1-15',3), 0.05);

    wf = require 'libraries/windfield/windfield';
    world = wf.newWorld (0, 700, false);
    world:setQueryDebugDrawing(true);

    world:addCollisionClass ('platform');
    world:addCollisionClass ('player' --[[{ignores = {'platform'}}]]);
    world:addCollisionClass ('danger');

    require('player')
   
    --danger_zone = world:newRectangleCollider (0, 550, 800, 50, {collision_class = "danger"});
    --danger_zone:setType('static');

    platforms = {}

    loadMap()
end

function love.update (dt)
    world:update (dt)  
    gameMap:update(dt)
    player_update(dt)
    
    local px, py = player:getPosition()
    cam:lookAt(px, love.graphics.getHeight()/2)
end 

function love.draw ()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        world:draw ()
        draw_player()
    cam:detach()
end

function love.keypressed (key)
    if key == 'w' then
        if player.grounded then
            player:applyLinearImpulse (0, -4000)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = world:queryCircleArea(x, y, 200, {'platform', 'danger'})
        for i,c in ipairs(colliders) do
            c:destroy()
        end
    end
end

function spawnPlatform(x, y, width, height)
    if width > 0 and height > 0 then
        local platform = world:newRectangleCollider (x, y, width, height, {collision_class = "platform"});
        platform:setType ('static');
        table.insert(platforms, platform)
    end
end

function loadMap()
    gameMap = sti("maps/LEVEL_1.lua")
    for i, obj in pairs(gameMap.layers["Platforms"].objects) do
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end
end
