local function split(str,delim)
  local t = {}
  for word in string.gmatch(str, "[^"..delim.."]+") do
    table.insert(t, word)
  end
  return t
end


-- READ INPUT 
local file = io.open("res/input.txt", "r")

local records = {}

local function parse_line(line)
     -- Parse line 
    -- Game 9:  
    --    SET 1  11 red, 2 blue;           13 CUBES  
    --    SET 2  1 blue, 9 green, 13 red;         23 CUBES
    --    SET 3  2 blue, 17 red, 6 green          25 CUBES 
    -- Games 1 : each ; is a set of  cubes with different colors 
    local game = {}
    -- parse number
    local game_to_match = string.find(line, ":")
    local game_number = string.sub(line, 0, game_to_match)
    game.number = tonumber(game_number:match("%d+"))
    -- parse sets 
    local split_w = string.sub(line, game_to_match + 1, #line )
    local split_set  = split(split_w, ";") -- split sets
    local sets = {}
    for _,set_w in pairs(split_set) do
      local cubes = split(set_w,",")
      local set   = {}
      for _,cube_w in pairs(cubes) do
        local parts = split(cube_w," ")
        local cube = {}
        cube.quantity = tonumber(parts[1]);
        cube.color    = parts[2];
        table.insert(set,cube)
      end
      table.insert(sets,set)
    end
    game.sets = sets
    table.insert(records, game)
end


if file then
  for line in file:lines() do
    parse_line(line)
  end
  file:close()
else
  print("Error: Could not open file")
end

print(records[1].number)
print(records[1].sets[1][1].color)

-- 12  red cubs 13 green cubes  14 blue cubes 
-- he putes the cubs back for each set so i just have to check each set to not have more than the max 
local function is_game_posible(game)
  local is_posible = true
  for  _,set in pairs(game.sets) do
    local red   = 0
    local blue  = 0
    local green = 0
    for _,cube in pairs(set) do
      if cube.color == "red" then
        red = cube.quantity
      end
      if cube.color == "blue" then
        blue = cube.quantity
      end
      if cube.color == "green" then
        green = cube.quantity
      end
    end
    if red > 12 or blue >14 or green > 13 then
      is_posible = false
    end
  end
  return is_posible
end

local total = 0
for _,game in pairs(records) do
  if is_game_posible(game) then
     total = total + game.number
  end
end
print(total)
-- sum of posible games 
--
--
--  PART 2
--
--
local function check_game2(game)
  local color_counts = {red = 0, blue = 0, green = 0}
  for  _,set in pairs(game.sets) do
    for _, cube in ipairs(set) do
        if color_counts[cube.color] < cube.quantity then
          color_counts[cube.color] = cube.quantity
        end
    end
  end
  return color_counts.red * color_counts.blue * color_counts.green
end


local minim_total = 0
for _,game in pairs(records) do
  minim_total = minim_total + check_game2(game)
end

print(minim_total)


