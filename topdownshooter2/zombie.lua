-- data type: table
local list = {};

-- data type: double
local last_spawn_time = 0.0;

-- data type: bool
local is_dead(table)
    if table.current_health <= 0.0 then
        return true;
    end

    return false;
end

-- data type: void
local generate_random_position(table) 
    local height = love.graphics.getHeight();
    local width = love.graphics.getWidth();

    local random_side = math.random(1, 4);
    if random_side == 1 then
        table.x = -30;
        table.y = math.random(0, height)
    elseif random_side == 2 then
        table.x = width + 30;
        table.y = math.random(0, height)
    elseif random_side == 3 then
        table.x = math.random(0, width)
        table.y = -30;
    elseif random_side == 4 then
        table.x = math.random(0, width)
        table.y = height + 30;
    end
end

-- data type: void
local spawn(list)
    local zombie = {};
    zombie.movement_speed = 100;
    zombie.max_health = 50;
    zombie.current_health = 50;

    zombie.x = 0.0;
    zombie.y = 0.0;
    generate_random_position(zombie);
    
    table.insert(list, zombie);
end

return
{
    list = list,
    is_dead = is_dead,
    generate_random_position = generate_random_position,
    spawn = spawn,
}
