--enemies

local group_factors = {
    [1] = 0.25,
    [2] = 0.375,
    [3] = 0.5,
    [4] = 1.0
}

-- enemy types, with corresponding sprite num
local octorok = {}
octorok.sprite = 64
octorok.name = "octorok"
octorok.strength = 5
octorok.agility = 3
octorok.dodge = 1/64
octorok.hp = 3
octorok.xp = 1
octorok.gp = 1
octorok.group_factor = 1
-- also SLEEP resist, STOPSPELL resist, HURT resist

enemies = {}

local function create_enemy(actor, type)
    local enemy = {
        actor = actor,
        type = type
    }
    add(enemies, enemy)
    return enemy
end

function spawn_enemy(x,y,sprite)
    local actor = create_actor(sprite, x, y, 7, 7, cant_move_enemy)

    local random_dir = random_range(0,3)
    if random_dir == 0 then
        actor.dx = 0.125 actor.dy = 0
    elseif random_dir == 1 then
        actor.dx = -0.125 actor.dy = 0
    elseif random_dir == 2 then
        actor.dx = 0 actor.dy = 0.125
    elseif random_dir == 3 then
        actor.dx = 0 actor.dy = -0.125
    end

    if sprite == octorok.sprite then
        create_enemy(actor, octorok)
    else
        printh("ERROR: spawn_enemy encountered unknown enemy type")
    end
end

local function handle_enemy_collision(enemy_index)
    init_battle(enemy_index)
    curr_state = battle
end

local function check_enemy_collision(index)
    -- more complex:
    -- for each enemy
    --   if enemy on different screen than player, do nothing
    --   else if enemy collides with player, call handle_enemy_collision, return
    for i = 1,#enemies do
        if  enemies[i].actor.enabled 
        and check_collision(p.actor, enemies[i].actor) then
            handle_enemy_collision(i)
        end
    end
end

function check_enemy_collisions()
    for i = 1,#enemies do
        if (enemies[i].actor.enabled) check_enemy_collision(i)
    end
end

function cant_move_enemy(actor)
    actor.dx *= -1
    actor.dy *= -1
end

function get_enemy_run_factor(enemy_type)
    return group_factors[enemy_type.group_factor]
end

function respawn_enemies()
    for i = 1,#enemies do 
        enemies[i].actor.enabled = true
    end
end