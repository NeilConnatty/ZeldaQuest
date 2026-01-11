-- systems around transporting to and from caves

local cave = {}
cave.x = 7
cave.y = 14
cave.curr_cave = nil
cave.cave_defs = {}

local doors = {}

local function update_sword(index)
    if check_collision(p.actor, cave.cave_defs[cave.curr_cave].objects[index])
    then
        take_sword(cave.cave_defs[cave.curr_cave].objects[index].attack)
        cave.cave_defs[cave.curr_cave].objects[index].enabled = false
    end
end

-- sword cave
cave.cave_defs["36:50"] = {}
cave.cave_defs["36:50"].objects = {}
cave.cave_defs["36:50"].objects[1] = {
    sprite = 4,
    x = 8,
    y = 10,
    w = 8,
    h = 8,
    attack = 4,
    update = update_sword,
    enabled = true
}
cave.cave_defs["36:50"].messages = {
    [1] = "it's dangerous to go",
    [2] = "alone! take this."
}
-- respawn cave
cave.cave_defs["0:0"] = {
    objects = {},
    messages = {
        [1] = "be careful out there",
        [2] = ""
    }
}


local function goto_cave(x,y)
    cave.curr_cave = x..":"..y
end

local function leave_cave(x,y)
    cave.curr_cave = nil
    respawn_enemies()
end

local function create_door(x,y, action)
    local door = {
        x = x,
        y = y,
        w = 8,
        h = 4,
        destx = nil,
        desty = nil,
        action = action
    }
    add(doors, door)
    return door
end

function init_doors()
    local door1 = create_door(7, 15, leave_cave)
    local door2 = create_door(8, 15, leave_cave)
    -- special door for when player dies
end

function add_door(x, y)
    local new_door = create_door(x, y, goto_cave)
    new_door.destx = cave.x
    new_door.desty = cave.y
end

local function enter_door(door)
    transport_player(door.destx, door.desty)
    door.action(door.x,door.y)
    doors[1].destx = door.x
    doors[1].desty = door.y+1
    doors[2].destx = door.x
    doors[2].desty = door.y+1
end

function check_door_collisions()
    for i= 1,#doors do 
        if check_collision(p.actor, doors[i]) then
            enter_door(doors[i])
            return
        end
    end
end

function update_cave()
    if (cave.curr_cave == nil) return
    
    local curr_cave = cave.cave_defs[cave.curr_cave]
    for i= 1,#curr_cave.objects do 
        if (curr_cave.objects[i].enabled) then
            curr_cave.objects[i].update(i)
        end
    end
end

function draw_cave()
    if (cave.curr_cave == nil) return

    local curr_cave = cave.cave_defs[cave.curr_cave]
    for i= 1,#curr_cave.objects do 
        local object = curr_cave.objects[i]
        if (object.enabled) spr(object.sprite, object.x*8, object.y*8)
    end

    local messx = (2*8)+2 local messy = (7*8)+2
    if (curr_cave.messages[1] != nil) print(curr_cave.messages[1], messx, messy)
    if (curr_cave.messages[2] != nil) print(curr_cave.messages[2], messx, messy+8)
end

function goto_respawn_cave()
    transport_player(cave.x, cave.y)
    cave.curr_cave = "0:0"
    doors[1].destx = 36
    doors[1].desty = 51
    doors[2].destx = 36
    doors[2].desty = 51
end
