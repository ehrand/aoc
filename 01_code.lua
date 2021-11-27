#!/usr/bin/env lua

------------------------------------------------------------------------------------------

-- This class is aimed to be used for reading of numbers from a file.
local Reader = {}
Reader.new = function(self, object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

---@diagnostic disable-next-line: unused-local
Reader.__call = function(self, file_name)
  if(type(file_name) ~= "string") then
    print("Please provide file containing numbers as a string!")
    return
  end

  local file = assert(
    io.open(file_name, "r"),
    "Failed to open file " .. file_name .. " for reading!")
  local lines = file:lines()
  local numbers = {}
  for line in lines do
    local number = tonumber(line)
    if(number) then
      table.insert(numbers, number)
    else
      print("Error converting line: " .. line)
    end
  end
  file:close()
  return numbers
end

------------------------------------------------------------------------------------------

local input    = "./01_data.txt"
local reader  = Reader:new()
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
