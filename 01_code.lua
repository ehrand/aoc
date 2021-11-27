#!/usr/bin/env lua

------------------------------------------------------------------------------------------

local input    = "./01_data.txt"
local reader  = require("reader"):new()
local numbers = reader(input)
local desired = 2020

while(#numbers > 2) do
  print("Remaining ... " .. #numbers)
  local base = table.remove(numbers, 1) -- base contains the first table element (that will be dropped in the ext iteration)
  local size = #numbers
  local key = 1
  while(key + 2 < size) do
    local idx = key + 1
    while(idx + 1 < size) do
      local sum = base + numbers[key] + numbers[idx]
      if(desired == sum) then
        local mul = base * numbers[key] * numbers[idx]
        print(sum .. " = " .. base .. " + " .. numbers[key] .. " + " .. numbers[idx])
        print(mul .. " = " .. base .. " * " .. numbers[key] .. " + " .. numbers[idx])
        return
      end
      idx = idx + 1
    end
    key = key + 1
  end
end
