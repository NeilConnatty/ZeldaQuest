-- battle screen

-- battle states
local player_turn = 0
local enemy_turn = 1
local wait_for_input = 2
local battle_end = 3

-- cursor states
local fight = 0 local spell = 1
local run = 2   local item = 3

-- messages
local messages = {}

function init_battle(enemy_index)
    enemy_type = enemies[enemy_index].type
    battle_enemy_index = enemy_index
    enemy_hp = enemy_type.hp 
    curr_battle_state = player_turn
    next_battle_state = player_turn
    curr_cursor = fight

    messages[1] = ""
    messages[2] = "an enemy "..enemy_type.name
    messages[3] = "draws near!"
    messages[4] = "command?"
end

local function add_message(string)
    add(messages, string)
end 

local function attack_enemy()
    local divisor = random_range(2,4)
    printh("random divisor: "..divisor)
    local damage = (p.strength - (enemy_type.agility \ 2)) \ divisor

    add_message("")
    add_message("Link attacks!")

    if (damage <= 0) then
        add_message(enemy_type.name.." dodged the attack.")
    else
        enemy_hp -= damage
        add_message(enemy_type.name.." takes "..damage.." damage.")
    end

    if (enemy_hp <= 0) then
        add_message(enemy_type.name.." defeated!")
        enemies[battle_enemy_index].actor.enabled = false

        p.gp += enemy_type.gp
        p.xp += enemy_type.xp
        curr_battle_state = battle_end
    else
        curr_battle_state = wait_for_input
        next_battle_state = enemy_turn
    end
end

local function attack_player()
    local divisor = random_range(2 ,4)
    local damage = (enemy_type.strength - (p.agility \ 2)) \ divisor

    add_message("")
    add_message(enemy_type.name.." attacks!")
    
    if (damage <= 0) then
        add_message("link dodged the attack.")
    else
        p.hp -= damage
        add_message("link takes "..damage.." damage.")
    end

    if (p.hp <= 0) then
        add(messages, "Link is dead.")
        curr_battle_state = battle_end
    else 
        curr_battle_state = wait_for_input
        next_battle_state = player_turn
    end
end

local function attempt_run()
    local player_factor = p.agility * random_range(0,255)
    local enemy_factor = enemy_type.agility * random_range(0,255) * get_enemy_run_factor(enemy_type)

    add_message("")
    add_message("Link attempts to run!")
    if (player_factor < enemy_factor) then
        add_message(enemy_type.name.." blocks run attempt.")
        curr_battle_state = wait_for_input
        next_battle_state = enemy_turn
    else
        add_message("Link runs from the battle!")
        enemies[battle_enemy_index].actor.enabled = false
        curr_battle_state = battle_end
    end
end

local function do_command()
    if curr_cursor == fight then
        attack_enemy()
elseif curr_cursor == run then
        attempt_run()
    elseif curr_cursor == spell then
        cast_spell()
    elseif curr_cursor == item then
        use_item()
    end
end

local function update_cursor()
    if btnp(left) or btnp(right) then
        if (curr_cursor == fight or curr_cursor == run) then
            curr_cursor += 1
        else
            curr_cursor -= 1
        end
    elseif btnp(up) or btnp(down) then
        if (curr_cursor == fight or curr_cursor == spell) then
            curr_cursor += 2
        else
            curr_cursor -= 2
        end 
    end
end

function update_battle()
    if curr_battle_state == player_turn then
        update_cursor()
        if (btnp(x_btn)) then
           do_command() 
        end
    elseif curr_battle_state == enemy_turn then
        attack_player()
    elseif curr_battle_state == battle_end then
        if (btnp(x_btn)) then
            curr_state = gameplay
            if (p.hp <= 0) respawn_player()
        end
    elseif curr_battle_state == wait_for_input then
        if (btnp(x_btn)) then
            curr_battle_state = next_battle_state
        end
    end
end

local function draw_player_stats()
    local winx = mapx*8 + 7
    local winy = mapy*8 + 7
    
    rectfill(winx, winy, winx+24, winy+64,0)
    rect(winx, winy, winx+24, winy+64,7)
    
    print("link", winx+5, winy+4, 7)
    print("lv "..p.level, winx+3, winy+14, 7)
    print("hp "..p.hp, winx+3, winy+24, 7)
    print("mp "..p.mp, winx+3, winy+34, 7)
    print("gp "..p.gp, winx+3, winy+44, 7)
    print("xp "..p.xp, winx+3, winy+54, 7)
end

local function draw_enemy()
    local centrex = mapx*8 + 64
    local centrey = mapy*8 + 64

    rectfill(centrex-6, centrey-6, centrex+6, centrey+6, 3)
    rect(centrex-7, centrey-7, centrex+7, centrey+7, 7)
    
    spr(enemy_type.sprite, centrex-4, centrey-4)
end

local function draw_commands()
    local winx = mapx*8 + 40
    local winy = mapy*8 + 7

    rectfill(winx, winy, winx+80, winy+32, 0)
    rect(winx, winy, winx+80, winy+32, 7)
    
    print("command", winx+24, winy+4, 7)
    print("fight", winx+12, winy+14, 7) print("spell", winx+52, winy+14, 7)
    print("run", winx+12, winy+24, 7)   print("item", winx+52, winy+24, 7)

    if (curr_cursor == fight) then
        spr(2, winx+3, winy+12)
    elseif (curr_cursor == spell) then
        spr(2, winx+43, winy+12)
    elseif (curr_cursor == run) then
        spr(2, winx+3, winy+22)
    elseif (curr_cursor == item) then
        spr(2, winx+43, winy+22)
    end
end

local function draw_info()
    local winx = mapx*8 + 15
    local winy = mapy*8 + 80

    rectfill(winx, winy, winx+(13*8) , winy+(5*8), 0)
    rect(winx, winy, winx+(13*8) , winy+(5*8), 7)

    for i = 0,3 do
        print(messages[#messages-i], winx+4, winy+4+((3-i)*8))
    end

    if (curr_battle_state == wait_for_input or curr_battle_state == battle_end) then
        spr(3, winx+(12*8), winy+(4*8), 1, 1)
    end
end

function draw_battle()
    draw_player_stats()
    draw_enemy()
    if (curr_battle_state == player_turn) draw_commands()
    draw_info()
end