local function get_angle_(x1, y1, x2, y2)
   return math.atan2(y1 - y2, x1 - x2) + math.pi;
end

local function get_angle(a, b)
    return get_angle_(a.x, a.y, b.x, b.y);
end
    
local function get_distance_(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5;
end

local function get_distance(a, b)
    return get_distance_(a.x, a.y, b.x, b.y);
end

local function get_position(table)
    table.position = {};
    table.position.x = table.x;
    table.position.y = table.y;
    return table.position;
end

local function get_game_dificulty(score)
    local game_dificulty = 1;

    if score > 10 then
        game_dificulty = 0.80;
    end

    if score > 30 then
        game_dificulty = 0.60;
    end

    if score > 60 then
        game_dificulty = 0.50;
    end
    
    if score > 80 then
        game_dificulty = 0.30;
    end

    if score > 100 then
        game_dificulty = 0.20;
    end

    return game_dificulty;
end

return
{ 
    get_angle_ = get_angle_,
    get_angle = get_angle,
    get_distance_ = get_distance_,
    get_distance = get_distance,
    get_position = get_position,
    get_game_dificulty = get_game_dificulty,
};