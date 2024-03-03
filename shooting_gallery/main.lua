love.window.setTitle("Shooting Gallery by Venus")

local target = {};   
-- data type: table
-- this is the target that we will shoot

local screen_width = love.graphics.getWidth();
local screen_height = love.graphics.getHeight();

target.radius = 50;
target.x = love.math.random(target.radius, screen_width - target.radius);
target.y = love.math.random(target.radius, screen_height - target.radius);

local score = 0;
-- data type: int
-- this is the points from hitting target

local timer = 0;
-- data type: double

local game_state = 1;
-- data type: int
-- gamestate means if the game is running or not 1=lobby 2=playing

local game_font = love.graphics.newFont(40);
-- https://love2d.org/wiki/love.graphics.newFont

local sprites = {};
-- data type: table
-- this is a table containing all the sprites that we will use in the game

local last_damage_time = 0.0;
-- data type: double
-- keep track of the last time received damage

local game_time = 0.0;
-- data type: double
-- keep track of each second of the game

sprites.sky = love.graphics.newImage('sprites/sky.png');
sprites.target = love.graphics.newImage('sprites/target.png');
sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png');

love.mouse.setVisible(false);

function love.update(dt)
    if timer > 0 then
        timer = timer - dt;
    end   

    if timer < 0 then
        timer = 0;
        game_state = 1;
    end
    game_time = game_time + dt;
end

function love.draw()
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(sprites.sky, 0, 0);
    -- drawing the background of the game, its first so later other drawings are on top

    love.graphics.setColor(255, 255, 255);
    love.graphics.setFont(game_font);
    love.graphics.print("Score: " .. score, 5, 5);

    local game_timer = math.ceil(timer);
    -- date type: int
    -- converting from timer float decimals to game_timer int 

    love.graphics.print("Time: " .. game_timer, 300, 5);

    if game_state == 1 then
        love.graphics.printf("Click to begin", 0, 250, screen_width, "center");
    end
    
    if game_state == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius);
    end

    local cursor_position_x = love.mouse.getX();
    local cursor_position_y = love.mouse.getY();
    love.graphics.draw(sprites.crosshairs, cursor_position_x -20, cursor_position_y -20);
    
    if game_time - last_damage_time < 0.33 and last_damage_time > 0.0 then
        love.graphics.setColor(255, 0, 0, 0.24);
        love.graphics.rectangle("fill", 0, 0, screen_width, screen_height);
    end
end

local function get_2d_distance(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5;
end

function love.mousepressed(x, y, button, istouch, presses)

    local score_increment = 1;
    if button == 2 then 
        score_increment = 2;
    end
    
    if game_state == 1 then
        game_state = 2; --start the game here
        timer = 10;
        score = 0;
        return;
    end

    if game_state == 2 then
        local distance = get_2d_distance(x, y, target.x, target.y);
        if distance <= target.radius then
            score = score + score_increment;
            target.x = love.math.random(target.radius, screen_width - target.radius);
            target.y = love.math.random(target.radius, screen_height - target.radius);
        else
            if game_time - last_damage_time > 0.5 then
                score = score - score_increment;
                last_damage_time = game_time;
            end
        end
    end
end