local utility = require ("utility");
local player = require ("player");
local zombie = require ("zombie");
local bullet = require ("bullet");

-- data type: table
-- the graphics
local sprites = {};

--time from persons computer to generate a seed
math.randomseed(os.time());

sprites.background = love.graphics.newImage('sprites/background.png');
sprites.bullet = love.graphics.newImage('sprites/bullet.png');
sprites.player = love.graphics.newImage('sprites/player.png');
sprites.zombie = love.graphics.newImage('sprites/zombie.png');

local my_font = love.graphics.newFont(30)

local game_state = 1;

-- data type: int 
local score = 0;

-- data type: double
local game_time = 0.0;

function love.update(dt)
    if game_state == 1 then    
        return;
    end

    player.move();

    game_time = game_time + dt;
    
    for i, z in ipairs(zombies) do
        z.x = z.x + (math.cos( utility.zombie_player_angle(z) ) * z.speed * dt);
        z.y = z.y + (math.sin( utility.zombie_player_angle(z) ) * z.speed * dt);

        if game_time - last_damage_time > 2 then

        if utility.get_2d_distance(z.x, z.y, utility.player.x, utility.player.y) < 30 then
            utility.player.current_health = utility.player.current_health - (utility.player.max_health * 0.5);
            utility.player.speed = 400;
            last_damage_time = game_time;
            if utility.player.current_health <= 0 then
                zombies[i] = nil; 
                game_state = 1;
                return;
            end
        end
    end
        for i = #bullets, 1, -1 do
            local b = bullets[i]
            if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
                table.remove(bullets, i)
            end
        end
         for i,z in ipairs(zombies) do
            for j,b in ipairs(bullets) do
                if utility.get_2d_distance(z.x, z.y, b.x, b.y) < 20 then
                    z.dead = true;
                    b.dead = true;
                    score = score + 1;
                end
            end
        end
        
           for i = #zombies,1,-1 do
            local h = zombies[i]
                if h.dead == true then
                    table.remove (zombies, i);
           end
        end
        for i = #bullets,1,-1 do
            local b = bullets[i]
            if b.dead == true then
             table.remove (bullets, i);
            end
        end
   
        if game_state == 2 then
            if game_time - last_zombie_time > 1 then
                last_zombie_time = game_time
                utility.spawn_zombie(zombies)
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

    if game_state == 1 then
        love.graphics.setFont(my_font)
        love.graphics.printf("Click to begin", 0, 50, love.graphics.getWidth(), "center");
    end
    love.graphics.printf("Score: " .. score, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center");

    love.graphics.printf("Hp: " .. utility.player.current_health, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "right");

    love.graphics.printf("Timer: " .. math.ceil(game_time), 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "left");

    local player_width = sprites.player:getWidth();
    local player_height = sprites.player:getHeight();
    love.graphics.draw(sprites.player, utility.player.x, utility.player.y, utility.player_mouse_angle(), nil, nil, player_width/2, player_height/2);

    local zombie_width = sprites.zombie:getWidth();
    local zombie_height = sprites.zombie:getHeight();

    for i, z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, utility.zombie_player_angle(z), nil, nil, zombie_width/2, zombie_height/2);
    end

    for i, b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, 0.5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2);
    end
end

function love.keypressed ( key )
    if key == "space" then
        utility.spawn_zombie(zombies);
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and game_state == 2 then
        utility.spawn_bullet(bullets);
    elseif button == 1 and game_state == 1 then
        game_state = 2;
        max_time = 2;
        timer = max_time;
        score = 0;
    end
end