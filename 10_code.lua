#!/usr/bin/env lua

local reader = require('reader'):new()
local data = reader('./10_data.txt')

local open_close_pairs = {
  { '(', ')' },
  { '[', ']' },
  { '{', '}' },
  { '<', '>' }
}
local ranking = {}
ranking[')'] = 3
ranking[']'] = 57
ranking['}'] = 1197
ranking['>'] = 25137

-- loop through all lines stored in 'data', iterate through every character in the
-- line and find first character not matching the pair stores in 'open_close_pairs'
local get_corrupted_ranking = function(line)
  local stack = {}
  for i = 1, #line, 1 do
    local c = line:sub(i, i)
    for _, pair in ipairs(open_close_pairs) do
      if (c == pair[1]) then
        -- store opening symbol
        table.insert(stack, c)
      elseif (c == pair[2]) then
        -- check if the closing symbol is correct
        local last = table.remove(stack)
        if (last ~= pair[1]) then
          return ranking[pair[2]]
        end
      end
    end
  end
  return 0
end

local score = 0
local data_maybe_incomplete = {}
for _, line in ipairs(data) do
  local _score = get_corrupted_ranking(line)
  if (_score == 0) then
    table.insert(data_maybe_incomplete, line)
  end
  score = score + _score
end
print('part 1: Score: ' .. score)

------------------------------------------------------------------------------------------

local get_closing_symbol = function(opening_symbol)
  for _, pair in ipairs(open_close_pairs) do
    if (opening_symbol == pair[1]) then
      return pair[2]
    end
  end
  assert(false, "Should never reach this point")
end

local get_completed_symbols = function(line)
  local stack = {}
  for i = 1, #line, 1 do
    local c = line:sub(i, i)
    for _, pair in ipairs(open_close_pairs) do
      if (c == pair[1]) then
        -- store opening symbol
        -- print('Stacking ' .. c)
        table.insert(stack, c)
      elseif (c == pair[2]) then
        -- check if the closing symbol is correct
        local last = stack[#stack]
        local expected = get_closing_symbol(last)
        if (c == expected) then
          -- print('Dropping ' .. last)
          table.remove(stack, #stack)
        end
      end
      -- print('Available: ' .. table.concat(stack, ','))
    end
  end
  local mirrored = {}
  for i = #stack, 1, -1 do
    table.insert(mirrored, get_closing_symbol(stack[i]))
  end
  -- print('Mirrored: ' .. table.concat(mirrored, ','))
  return mirrored
end

ranking[')'] = 1
ranking[']'] = 2
ranking['}'] = 3
ranking['>'] = 4
local scores_all = {}
for _, line in ipairs(data_maybe_incomplete) do
  local missing = get_completed_symbols(line)
  score = 0
  for i = 1, #missing do
    local char = missing[i]
    score = (score * 5) + ranking[char]
  end
  -- if (score > 0) then
  table.insert(scores_all, score)
  -- end
end

table.sort(scores_all)
for k, v in ipairs(scores_all) do
  if (k > #scores_all / 2) then
    print('part 2: Score: [' .. k .. ']: ' .. v)
    break
  end
end
