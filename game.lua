-- main game loop

function _init()
	map_setup()
	make_player()
    init_game_state()
	
	game_win=false
	game_over=false
end

function _update()
	if (not game_over) then
		update_game()
    else
		if (btnp(❎)) extcmd("reset")
	end
end

function _draw()
	cls()
	if (not game_over) then
		draw_game()
	else
		draw_win_lose()
	end
end

function draw_win_lose()
	camera()
	if (game_win) then
		print("★ you win! ★",37,64,7)
	else
		print("game over! :(",38,64,7)
	end
	print("press ❎ to play again",20,72,7)
end
