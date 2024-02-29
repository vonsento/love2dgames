local target = {};   
-- data type: table
-- this is the target that we will shoot

target.radius = 50;
target.x = math.random(target.radius, love.graphics.getWidth() - target.radius);
target.y = math.random(target.radius, love.graphics.getHeight() - target.radius);

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
end

function love.draw()
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
        love.graphics.printf("Click to begin", 0, 250, love.graphics.getWidth(), "center");
    end
    
    if game_state == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius);
    end

    love.graphics.draw(sprites.crosshairs, love.mouse.getX()-20, love.mouse.getY()-20);
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
        local distance = distanceBetween(x, y, target.x, target.y);
        if distance <= target.radius then
            score = score + score_increment;
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius);
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius);
        else
            score = score - score_increment;
        end
    end
end
 
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end