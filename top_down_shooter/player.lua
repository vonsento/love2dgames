local screen_width = love.graphics.getWidth();
local screen_height = love.graphics.getHeight();

local player = {};




player.position = {};
player.position.x = player.x;
player.position.y = player.y;

-- data type: table
function player.get_position()
    player.position.x = player.x;
    player.position.y = player.y;
    return player.position;
end

-- data type: int
player.movement_speed = 300;

-- data type: int
player.max_health = 100; 

-- data type: int
player.current_health = 100; 

-- data type: double
player.last_damage_time = 0.0; 

function player.move(dt)
    if love.keyboard.isDown("d") and player.x < screen_width then
        player.x = player.x + player.movement_speed * dt;
    end

    if love.keyboard.isDown("a") and player.x > 0 then
        player.x = player.x - player.movement_speed * dt;
    end

    if love.keyboard.isDown("w") and player.y > 0 then
        player.y = player.y - player.movement_speed * dt;
    end

    if love.keyboard.isDown("s") and player.y < screen_height then
        player.y = player.y + player.movement_speed * dt;
    end
end

return player;
