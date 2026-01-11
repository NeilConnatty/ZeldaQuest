-- generic actor code -- manages drawing & collisions

actors = {}

function create_actor(sprite, x, y, w, h, cant_move_callback)
    a = {
        sprite = sprite,
        -- position in tile coordinates
        x = x,
        y = y,
        dx = 0,
        dy = 0,
        -- hitbox in pixel size
        w = w,
        h = h,
        enabled = true,
        cant_move_callback = cant_move_callback
    }

    add(actors, a)
    return a
end

local function draw_actor(actor)
    if (actor.enabled) spr(actor.sprite, flr(actor.x*8), flr(actor.y*8))
end

function draw_actors()
    foreach(actors, draw_actor)
end

local function point_inside(x1, y1, x2, y2, w2, h2)
    if  x1 >= x2 and x1 <= x2+7
    and y1 >= y2 and y1 <= y2+7 then
        return true
    end
end

function check_collision(actor1, actor2)
    local x1,y1 = actor1.x*8, actor1.y*8
    local w1, h1 = actor1.w-1, actor1.h-1 -- -1, like in 0-indexed arrays
    local x2,y2 = actor2.x*8, actor2.y*8
    local w2, h2 = actor2.w-1, actor2.h-1

    return point_inside(x1, y1, x2, y2, w2, h2) 
        or point_inside(x1, y1+h1, x2, y2, w2, h2)
        or point_inside(x1+w1, y1, x2, y2, w2, h2)
        or point_inside(x1+w1, y1+h1, x2, y2, w2, h2)
end

local function move_actor(actor)
    if not actor.enabled then 
        return 
    end

    if actor.dx == 0 and actor.dy == 0 then 
        return 
    end

    local newx = actor.x + actor.dx
    local newy = actor.y + actor.dy

    -- check can_move for all four corners of the sprite
    -- ideally p.x & p.y are in pixel coordinates, not tile.. oh well
    if  can_move(newx,newy)
    and can_move(newx,newy+0.875)
    and can_move(newx+0.875,newy)
    and can_move(newx+0.875,newy+0.875) then
		actor.x=mid(0,newx,127)
		actor.y=mid(0,newy,63)
	else
        actor.cant_move_callback(actor)
	end
end

function move_actors()
    foreach(actors, move_actor)
end
