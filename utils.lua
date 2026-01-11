-- utils

-- return a random number from [floor, roof] inclusive
function random_range(floor, roof)
    return flr(rnd(roof-1)) + floor
end
