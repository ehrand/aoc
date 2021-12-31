#!/usr/bin/env lua

local reader = require('reader'):new()
local data = reader('./09_data.txt')
local preamble_size = 25
assert(preamble_size < #data, 'Preamble needs to be smaller than available data set!')

local sequence_of_numbers_building_sum = function(sum, values)
  local accumulated = 0
  for k, v in ipairs(values) do
    accumulated = accumulated + tonumber(v, 10)
    if (accumulated > sum) then
      return false
    elseif (accumulated == sum) then
      local res = { table.unpack(values, 1, k) }
      for i, _ in pairs(res) do
        -- make sure the table contains numbers
        if (type(res[i] ~= "number")) then
          res[i] = tonumber(res[i])
        end
      end
      return res
    end
  end
  return false
end

-- i will point to the current number in the sequence
for i = preamble_size + 1, #data, 1 do
  local sum       = tonumber(data[i], 10)
  local idx_first = i - preamble_size
  local idx_last  = i - 1
  print(string.format("Analyzing number [%4d/%4d] (%d) with preamble [%4d - %4d]", i, #data, data[i], idx_first, idx_last))

  local preamble = { table.unpack(data, idx_first, idx_last) }
  local valid = false
  -- k will point to preamble[1..25]
  for k, v in ipairs(preamble) do
    local n1 = tonumber(v)
    local remaining = { table.unpack(preamble, k, #preamble) }
    for _, x in ipairs(remaining) do
      if (n1 + tonumber(x, 10) == sum) then
        valid = true
      end
    end
  end

  if not valid then
    print('Found number ' .. sum)
    -- only numbers in front of the current number are interesting now
    local subset = { table.unpack(data, 1, i - 1) }
    for k, _ in ipairs(subset) do
      local to_process = { table.unpack(subset, k, #subset) }
      local result = sequence_of_numbers_building_sum(sum, to_process)
      if (result) then
        local min = math.min(table.unpack(result))
        local max = math.max(table.unpack(result))
        print('Found subtable [' .. k .. '/' .. (k + #result - 1) .. ']: ' .. table.concat(result, ', '))
        print('[' .. (min + max) .. '] = [' .. min .. ' + ' .. max .. ']')
        return
      end
    end
  end
  i = i + 1
end
