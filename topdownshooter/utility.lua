local player = {};
-- data type: table
-- the character the player controls

player.x = love.graphics.getWidth() / 2;
player.y = love.graphics.getHeight() / 2;
player.speed = 180;

local function player_mouse_angle()
    return math.atan2( player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi;
end

local function zombie_player_angle(enemy)
    return math.atan2( player.y - enemy.y, player.x - enemy.x);
end

local function spawn_zombie(zombies)
    local zombie = {};
    zombie.x = math.random(0, love.graphics.getWidth());
    zombie.y = math.random(0, love.graphics.getHeight());
    zombie.speed = 100;
    table.insert(zombies, zombie);
end
    
local function spawn_bullet(bullets)
    local bullet = {};
    bullet.x = player.x;
    bullet.y = player.y;
    bullet.speed = 500;
    bullet.direction = player_mouse_angle();
    table.insert(bullets, bullet);
end

local function get_2d_distance(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5;
end

return
{ 
    player = player, 
    player_mouse_angle = player_mouse_angle,
    zombie_player_angle = zombie_player_angle,
    spawn_zombie = spawn_zombie,
    spawn_bullet = spawn_bullet,
    get_2d_distance = get_2d_distance,
};