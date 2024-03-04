love.window.setTitle( "Zombie Game" )

local screen_width = love.graphics.getWidth();
local screen_height = love.graphics.getHeight();

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

local my_font = love.graphics.newFont(30);

local game_state = 1;

-- data type: int 
local score = 0;

-- data type: double
local game_time = 0.0;

function love.update(dt)    
    if game_state == 1 then    
        return;
    end

    game_time = game_time + dt;
    player.move(dt);

    local game_dificulty = utility.get_game_dificulty(score);

    if game_time - zombie.last_spawn_time > game_dificulty then
        zombie.spawn(zombie.list, score);
        zombie.last_spawn_time = game_time;        
    end

    -- store player position here to use it multiple times
    local player_position = player.get_position();
    
    -- looping thru all zombies and moving them forward
    for i, unit in ipairs(zombie.list) do
        local unit_position = utility.get_position(unit);
        local zombie_angle_player = utility.get_angle(unit_position, player_position);

        unit.x = unit.x + (math.cos( zombie_angle_player ) * unit.movement_speed * dt);
        unit.y = unit.y + (math.sin( zombie_angle_player ) * unit.movement_speed * dt);
    end

    if game_time - player.last_damage_time > 1.5 then

        -- looping thru all zombies and checking if any of them collide with player
        for i, unit in ipairs(zombie.list) do
            local unit_position = utility.get_position(unit);
            local distance = utility.get_distance(player_position, unit_position);
            
            if distance < 30.0 then
                player.movement_speed = 400;
                player.last_damage_time = game_time;
                player.current_health = player.current_health - (player.max_health * 0.5);
                if player.current_health <= 0 then
                    zombie.list = {};
                    bullet.list = {};
                    game_state = 1;
                    return;
                end
            end
        end
    end    

    -- move bullets forward each frame
    for i, unit in ipairs(bullet.list) do
        unit.x = unit.x + (math.cos( unit.direction) * unit.speed * dt);
        unit.y = unit.y + (math.sin( unit.direction) * unit.speed * dt);
    end

    -- remove bullets outside of screen
    for i = #bullet.list, 1, -1 do
        local unit = bullet.list[i]
        local is_out_of_screen = unit.x < 0 or unit.y < 0 or unit.x > screen_width or unit.y > screen_height;
        if is_out_of_screen then
            table.remove(bullet.list, i)
        end
    end

    for i,z in ipairs(zombie.list) do
        local zombie_position = utility.get_position(z);

        for j,b in ipairs(bullet.list) do
            local bullet_position = utility.get_position(b);
            local distance = utility.get_distance(zombie_position, bullet_position);

            if distance < 20.0 then
                b.dead = true;
                z.current_health = 0.0;                
                score = score + 1;
            end
        end
    end

    for i, unit in ipairs(zombie.list) do
        local zombie_position = utility.get_position(unit);
        local distance = utility.get_distance(zombie_position, player_position);
        local is_close = distance < 30.0;
        if is_close then
            unit.current_health = 0;
        end
    end

    for i = #zombie.list,1,-1 do
        local unit = zombie.list[i]
        if zombie.is_dead(unit) then
            table.remove (zombie.list, i);
        end
    end

    for i = #bullet.list,1,-1 do
        local b = bullet.list[i]
        if b.dead == true then
            table.remove (bullet.list, i);
        end
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0);

    if game_state == 1 then
        love.graphics.setFont(my_font)
        love.graphics.printf("Press Space To Begin", 0, 50, screen_width, "center");
    end

    -- draw game time on left
    love.graphics.printf("Timer: " .. math.ceil(game_time), 0, screen_height - 100, screen_width, "left");

    -- draw player score on center
    love.graphics.printf("Score: " .. score, 0, screen_height - 100, screen_width, "center");

    -- draw player current health on right
    love.graphics.printf("Hp: " .. player.current_health, 0, screen_height - 100, screen_width, "right");    

    -- store player position here to use it multiple times
    local player_position = player.get_position();

    -- create a table holding current cursor position x and y
    local cursor_position = { };
    cursor_position.x = love.mouse.getX();
    cursor_position.y = love.mouse.getY();

    -- store the player sprite current width and height
    local player_width = sprites.player:getWidth();
    local player_height = sprites.player:getHeight();

    -- data type: double
    -- this is angle of player towards cursor position
    local player_angle_cursor = utility.get_angle(player_position, cursor_position); 
    if player.current_health < 100 then
        love.graphics.setColor (1, 0, 0);
    end

    love.graphics.draw(sprites.player, player_position.x, player_position.y, player_angle_cursor, nil, nil, player_width * 0.5, player_height * 0.5);
    love.graphics.setColor (1, 1, 1);
    
    -- store the zombie sprite current width and height
    local zombie_width = sprites.zombie:getWidth();
    local zombie_height = sprites.zombie:getHeight();

    for i, unit in ipairs(zombie.list) do
        local unit_position = utility.get_position(unit);
        local zombie_angle_player = utility.get_angle(unit_position, player_position);
        love.graphics.draw(sprites.zombie, unit_position.x, unit_position.y, zombie_angle_player, nil, nil, zombie_width * 0.5, zombie_height * 0.5);
    end

    -- store the bullet sprite current width and height
    local bullet_width = sprites.bullet:getWidth();
    local bullet_height = sprites.bullet:getHeight();

    for i, unit in ipairs(bullet.list) do
        love.graphics.draw(sprites.bullet, unit.x, unit.y, nil, 0.5, 0.5, bullet_width * 0.5, bullet_height * 0.5);
    end
end

function love.keypressed ( key )
    if key ~= "space" then
        return;
    end

    if game_state ~= 1 then
        return;
    end

    -- switch from game state 1 to 2 (game starts)

    -- reset timers
    game_time = 0;
    zombie.last_spawn_time = 0.0;
    player.last_damage_time = 0.0;

    -- reset score
    score = 0;

    -- start game
    game_state = 2;

    player.current_health = player.max_health;
end

function love.mousepressed(x, y, button)
    if game_state ~= 2 then
        return;
    end

    if button ~= 1 then
        return;
    end

    -- store player position here to use it multiple times
    local player_position = player.get_position();

    -- create a table holding current cursor position x and y
    local cursor_position = { };
    cursor_position.x = love.mouse.getX();
    cursor_position.y = love.mouse.getY();

    local bullet_angle_cursor = utility.get_angle(player_position, cursor_position);
    bullet.spawn(bullet.list, player, bullet_angle_cursor);
end