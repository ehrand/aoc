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

while(#numbers > 1) do
  print("Remaining ... " .. #numbers)
  local head = table.remove(numbers, 1)
  for _, v in ipairs(numbers) do
    local sum = head + v
    if(desired == sum) then
      local mul = head * v
      print(sum .. " = " .. head .. " + " .. v)
      print(mul .. " = " .. head .. " * " .. v)
      return
    end
  end
end
