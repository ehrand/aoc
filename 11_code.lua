#!/usr/bin/env lua

local reader = require("reader"):new()
local data = reader("./11_data.txt")
local counter = 0

local energy_print = function(nums)
  print("energy_print...")
  for idx, row in pairs(nums) do
    print(string.format("[%02d] ~> [%s]", idx, table.concat(row, ' ')))
  end
end

local energy_increment_all = function(nums)
  print('energy_increment...')
  for _, row in pairs(nums) do
    for i = 1, #row do
      row[i] = row[i] + 1
    end
  end
end

local energy_flash = function(idx_row, idx_col, numbers)
  numbers[idx_row][idx_col] = 0
  counter = counter + 1
  print(string.format("energy_flash [%02d] [%02d] ~> [%04d]", idx_row, idx_col, counter))
  for r = idx_row - 1, idx_row + 1 do
    for c = idx_col - 1, idx_col + 1 do
      if (r > 0 and c > 0 and r < 11 and c < 11) then
        if (numbers[r][c] > 0) then
          numbers[r][c] = numbers[r][c] + 1
        end
      end
    end
  end
end

local energy_find_first_flashable = function(nums)
  for idx_row, row in pairs(nums) do
    for idx_col, energy_level in pairs(row) do
      if (energy_level > 9) then
        return idx_row, idx_col
      end
    end
  end
  return nil, nil
end

local energy_sum = function(nums)
  local sum = 0
  for _, row in pairs(nums) do
    for _, energy_level in pairs(row) do
      sum = sum + energy_level
    end
  end
  return sum
end

------------------------------------------------------------------------------------------

-- convert 'data' into two dimensional integer array
local numbers = {}
for _, row in pairs(data) do
  local line = {}
  for i = 1, #row do
    local char = row:sub(i, i)
    table.insert(line, tonumber(char))
  end
  table.insert(numbers, line)
end

------------------------------------------------------------------------------------------

for i = 1, 1000 do
  print(string.format("Step [%02d]", i))
  energy_increment_all(numbers)
  local idx_row, idx_col = energy_find_first_flashable(numbers)
  while (idx_row and idx_col) do
    energy_print(numbers)
    energy_flash(idx_row, idx_col, numbers)
    idx_row, idx_col = energy_find_first_flashable(numbers)
  end

  if (energy_sum(numbers) == 0) then
    print(string.format("All octopuses flashed during step [%04d]", i))
    break
  end
end

print(string.format("Counter: %d", counter))
