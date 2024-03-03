-- data type: double
local x = love.graphics.getWidth() * 0.5;
-- data type: double
local y = love.graphics.getHeight() * 0.5; 
-- data type: table
local position = {x, y}; 
-- data type: int
local movement_speed = 200; 
-- data type: int
local max_health = 100; 
-- data type: int
local current_health = 100; 

-- data type: double
local last_damage_time = 0.0; 

local function move()
    if love.keyboard.isDown("d") and x < love.graphics.getWidth() then
        x = x + movement_speed * dt;
    end

    if love.keyboard.isDown("a") and x > 0 then
        x = x - movement_speed * dt;
    end

    if love.keyboard.isDown("w") and y > 0 then
        y = y - movement_speed * dt;
    end

    if love.keyboard.isDown("s") and y < love.graphics.getHeight() then
        y = y + movement_speed * dt;
    end
end

return
{
    x = x,
    y = y,
    position = position,
    movement_speed = movement_speed,
    max_health = max_health,
    current_health = current_health,
    move = move;
    last_damage_time = last_damage_time;
}
