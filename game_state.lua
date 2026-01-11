--win/lose code

--states
gameplay = 0
battle = 1

function init_game_state()
    curr_state = gameplay
end

function check_win_lose()
    if (p.hp <=0) game_over = true
end

function update_game()
    if (curr_state == gameplay) then
        update_map()
        update_cave()

		handle_player_input()
        move_actors()
        
        check_door_collisions()
        check_enemy_collisions()
		
        check_win_lose()
    elseif (curr_state == battle) then
        update_battle()
    end
end

function draw_game()
    draw_map()
    draw_cave()
	draw_actors()
    if (curr_state == battle) then
        draw_battle()
    end
end 
