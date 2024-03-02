local player = {};
-- data type: table
-- the character the player controls

player.x = love.graphics.getWidth() / 2;
player.y = love.graphics.getHeight() / 2;
player.speed = 180;
player.current_health = 100;
player.max_health = 100;

local function player_mouse_angle()
    return math.atan2( player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi;
end

local function zombie_player_angle(enemy)
    return math.atan2( player.y - enemy.y, player.x - enemy.x);
end

local function spawn_zombie(zombies)
    local zombie = {}
    zombie.x = 0;
    zombie.y = 0;
    zombie.speed = 100;
    zombie.dead = false;
    
    local side = math.random( 1, 4);
    if side == 1 then
        zombie.x = -30;
        zombie.y = math.random( 0, love.graphics.getHeight())
    elseif side == 2 then
        zombie.x = love.graphics.getWidth() + 30;
        zombie.y = math.random( 0, love.graphics.getHeight())
    elseif side == 3 then
        zombie.x = math.random( 0, love.graphics.getWidth())
        zombie.y = -30;
    elseif side == 4 then
        zombie.x = math.random( 0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30;
    end
    table.insert(zombies, zombie);
end
    
local function spawn_bullet(bullets)
    local bullet = {};
    bullet.x = player.x;
    bullet.y = player.y;
    bullet.speed = 500;
    bullet.dead = false;
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