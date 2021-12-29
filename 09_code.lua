#!/usr/bin/env lua

local reader = require('reader'):new()
local data = reader('./09_data.txt')
local preamble_size = 25
assert(preamble_size < #data, 'Preamble needs to be smaller than available data set!')

-- i will point to the current number in the sequence
for i = preamble_size + 1, #data, 1 do
  local sum = tonumber(data[i], 10)
  local idx_first = i - preamble_size
  local idx_last  = i - 1
  print(string.format("Analyzing number [%s] with preamble [%s - %s]", i, idx_first, idx_last))

  local preamble = {table.unpack(data, idx_first, idx_last)}
  local valid = false
  -- k will point to preamble[1..24]
  for k,v in pairs(preamble) do
    local n1 = tonumber(v)
    local remaining = {table.unpack(preamble, k, #preamble)}
    for _, x in pairs(remaining) do
      if (n1 + tonumber(x, 10) == sum) then
        valid = true
      end
    end
  end

  if not valid then
    print('Found number ' .. sum)
    return
  end
  i = i + 1
end
