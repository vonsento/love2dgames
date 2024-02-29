local utility = require("utility");

local sprites = {};
-- data type: table
-- the graphics

sprites.background = love.graphics.newImage('sprites/background.png');
sprites.bullet = love.graphics.newImage('sprites/bullet.png');
sprites.player = love.graphics.newImage('sprites/player.png');
sprites.zombie = love.graphics.newImage('sprites/zombie.png');

local zombies = {};
-- data type: table

local bullets = {};
-- data type: table

function love.update(dt)
    if love.keyboard.isDown("d") then
        utility.player.x = utility.player.x + utility.player.speed*dt;
    end

    if love.keyboard.isDown("a") then
        utility.player.x = utility.player.x - utility.player.speed*dt;
    end

    if love.keyboard.isDown("w") then
        utility.player.y = utility.player.y - utility.player.speed*dt;
    end

    if love.keyboard.isDown("s") then
        utility.player.y = utility.player.y + utility.player.speed*dt;
    end

    for i, z in ipairs(zombies) do
        z.x = z.x + (math.cos( utility.zombie_player_angle(z) ) * z.speed * dt);
        z.y = z.y + (math.sin( utility.zombie_player_angle(z) ) * z.speed * dt);

        if utility.get_2d_distance(z.x, z.y, utility.player.x, utility.player.y) < 100 then
            for i, z in ipairs(zombies) do
                zombies[i] = nil;
            end
        end
    end

    for i, b in ipairs(bullets) do
    b.x = b.x + (math.cos( b.direction) * b.speed * dt);
    b.y = b.y + (math.sin( b.direction) * b.speed * dt);
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0);

    local player_width = sprites.player:getWidth();
    local player_height = sprites.player:getHeight();
    love.graphics.draw(sprites.player, utility.player.x, utility.player.y, utility.player_mouse_angle(), nil, nil, player_width/2, player_height/2);

    local zombie_width = sprites.zombie:getWidth();
    local zombie_height = sprites.zombie:getHeight();

    for i, z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, utility.zombie_player_angle(z), nil, nil, zombie_width/2, zombie_height/2);
    end

    for i, b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y);
    end
end

function love.keypressed ( key )
    if key == "space" then
        utility.spawn_zombie(zombies);
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        utility.spawn_bullet(bullets);
    end
end