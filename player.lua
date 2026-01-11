--player code

function make_player()
    actor = create_actor(1, 38, 56, 7, 7, cant_move_player)
	p={}
	p.actor = actor
	p.keys=0
    p.hp = 15
    p.mp = 0
    p.gp = 0
    p.xp = 0
    p.level = 1
    p.strength = 0
    p.agility = 4
    p.speed = 0.125
    p.level = 1
end

local function interact(x,y)
	if (is_tile(key,x,y)) then
		get_key(x,y)
	elseif (is_tile(door,x,y) and p.keys>0) then
		open_door(x,y)
	end	
end

local function get_key(x,y)
	p.keys+=1
	swap_tile(x,y)
	sfx(1)
end

local function open_door(x,y)
	p.keys-=1
	swap_tile(x,y)
	sfx(2)
end

local function smooth_move_player()
    -- smooth movement, 4-way (I don't want to normalize diagonals)
    -- if dir button goes down that frame (i.e. wasn't already down) set deltax/y
    -- prioritize new dir buttons that go down that frame
    -- if two dir buttons go down in the same frame... arbitrary which wins
    local dx,dy = 0,0

    if btn(left) then 
        dx = -1*p.speed dy = 0
    end
    if btn(right) then
        dx = p.speed dy = 0
    end
    if btn(up) then
        dx = 0 dy = -1*p.speed
    end
    if btn(down) then
        dx = 0 dy = p.speed
    end

    p.actor.dx = dx
    p.actor.dy = dy
end

local function old_move_player()
    local newx=p.actor.x
	local newy=p.actor.y
	
	if (btnp(⬅️)) newx-=1
	if (btnp(➡️)) newx+=1
	if (btnp(⬆️)) newy-=1
	if (btnp(⬇️)) newy+=1
	
	interact(newx,newy)
	
	if (can_move(newx,newy)) then
		p.actor.x=mid(0,newx,127)
		p.actor.y=mid(0,newy,63)
	else
		sfx(0)
	end
end

function handle_player_input()
    smooth_move_player()
end

function transport_player(x, y)
    p.actor.x = x
    p.actor.y = y
end

function get_player_pos()
    return p.actor.x, p.actor.y
end

function take_sword(attack)
    p.strength += attack
end

function cant_move_player(actor)
	sfx(0)
end

function respawn_player()
    -- todo change to respect player's max level hp
    p.hp = 15
    goto_respawn_cave()
end
