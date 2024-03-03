-- data type: table
local list = {};

-- data type: void
local function spawn(list, player, direction)
    local bullet = {};
    bullet.x = player.x;
    bullet.y = player.y;  
    bullet.speed = 500;
    bullet.dead = false;
    bullet.direction = direction;
    table.insert(list, bullet);
end

return
{
    list = list,
    spawn = spawn,
}
