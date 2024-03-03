local function get_angle_(x1, y1, x2, y2)
   return math.atan2(y1 - y2, x1 - x2) + math.pi;
end

local function get_angle(a, b)
    return get_angle(a.x, a.y, b.x, b.y);
end
    
local function get_distance_(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5;
end

local function get_distance(a, b)
    return get_distance(a.x, a.y, b.x, b.y);
end

return
{ 
    get_angle_ = get_angle_,
    get_angle = get_angle,
    get_distance_ = get_distance_,
    get_distance = get_distance,
};