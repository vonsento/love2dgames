-- data type: table
local list = {};

-- data type: double
local last_spawn_time = 0.0;

-- data type: bool
local function is_dead(table)
    if table.current_health <= 0.0 then
        return true;
    end

    return false;
end

-- data type: void
local function generate_random_position(table) 
    local width = love.graphics.getWidth();
    local height = love.graphics.getHeight();

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

local function get_dynamic_speed(score)
    local movement_speed = 180;

    if score > 20 then
        movement_speed = 200;
    end

    if score > 40 then
        movement_speed = 220;
    end

    if score > 70 then
        movement_speed = 240;
    end
    
    if score > 90 then
        movement_speed = 250;
    end

    return movement_speed;
end

-- data type: void
local function spawn(list, score)
    local zombie = {};
    zombie.movement_speed = get_dynamic_speed(score);
    zombie.max_health = 50;
    zombie.current_health = 50;

    zombie.x = 0.0;
    zombie.y = 0.0;
    generate_random_position(zombie);

    zombie.position = {};
    zombie.position.x =  zombie.x;
    zombie.position.y =  zombie.y;

    table.insert(list, zombie);
end

return
{
    list = list,
    is_dead = is_dead,
    generate_random_position = generate_random_position,
    spawn = spawn,
    last_spawn_time = last_spawn_time,
}
