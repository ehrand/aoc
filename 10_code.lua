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
local find_first_mismatch = function(line)
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
for _, line in ipairs(data) do
  score = score + find_first_mismatch(line)
  print('Score: ' .. score)
end
