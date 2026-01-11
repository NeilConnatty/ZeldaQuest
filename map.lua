--map code

function map_setup()
	--timers
	timer=0
	anim_time=30 --30 = 1 second
	
	--map tile settings
	wall=0
	key=1
	door=2
	anim1=3
	anim2=4
	--for_later=5
    player=6
    enemy=7

    -- some helpful global sprites
    grass = 16
	dirt = 39

    init_doors()

    -- check each tile on map
    -- if enemy, then swap map tile with grass and spawn enemy
    for i = 0,127 do
        for j = 0,63 do
            if (is_tile(enemy,i,j)) then
                spawn_enemy(i,j,mget(i,j))
                mset(i,j,dirt)
			elseif (is_tile(door,i,j)) then
				add_door(i,j)
			end
        end
    end
end

function update_map()
	if (timer<0) then
		toggle_tiles()
		timer=anim_time
	end
	timer-=1
end

function draw_map()
	local x,y = get_player_pos()
	mapx=flr(x/16)*16
	mapy=flr(y/16)*16
	camera(mapx*8,mapy*8)
	map(0,0,0,0,128,64)
end

function is_tile(tile_type,x,y)
	tile=mget(x,y)
	has_flag=fget(tile,tile_type)
	return has_flag
end

function can_move(x,y)
	return not is_tile(wall,x,y)
end

function swap_tile(x,y)
	tile=mget(x,y)
	mset(x,y,tile+1)
end

function unswap_tile(x,y)
	tile=mget(x,y)
	mset(x,y,tile-1)
end

function toggle_tiles()
	for x=mapx,mapx+15 do
		for y=mapy,mapy+15 do
			--swap tiles as needed
			if (is_tile(anim1,x,y)) then
				swap_tile(x,y)
				sfx(3)
			elseif (is_tile(anim2,x,y)) then
				unswap_tile(x,y)
				sfx(3)
			end
		end
	end
end
