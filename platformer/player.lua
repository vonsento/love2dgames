player = world:newRectangleCollider (360, 100, 40, 100, {collision_class = "player"});
player:setFixedRotation(true)
player.speed = 240;
player.animation = animations.idle;
player.is_moving = false;
player.direction = 1;
player.grounded = true;

function player_update(dt)
    if player.body then
        local colliders = world:queryRectangleArea(player:getX() - 20, player:getY() + 50, 40, 2, {'platform'})
        if #colliders > 0 then
            player.grounded = true;
        else
            player.grounded = false;
        end
        player.is_moving = false
        local px, py = player:getPosition ()
        if love.keyboard.isDown ('d') then
            player:setX (px + player.speed * dt)
            player.is_moving = true;
            player.direction = 1;
        end
        if love.keyboard.isDown ('a') then
            player:setX (px - player.speed * dt)
            player.is_moving = true;
            player.direction = -1;
        end
        if player:enter ('danger') then
            player:destroy()
        end
    end
    if player.grounded then
        if player.is_moving then
            player.animation = animations.run;
        else
            player.animation = animations.idle;
        end
    else
        player.animation = animations.jump;
    end
end

function draw_player()
    local px, py = player:getPosition()
    player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 300)
end
