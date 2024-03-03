function love.load ()
    anim8 = require 'libraries/anim8/anim8';

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
   
    platform = world:newRectangleCollider (250, 400, 300, 100, {collision_class = "platform"});
    platform:setType ('static');

    danger_zone = world:newRectangleCollider (0, 550, 800, 50, {collision_class = "danger"});
    danger_zone:setType('static');
end

function love.update (dt)
    world:update (dt)  
    player_update(dt)      
end 

function love.draw ()
    world:draw ()
    draw_player()
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