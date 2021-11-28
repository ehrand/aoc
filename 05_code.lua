#!/usr/bin/env lua

local reader = require("reader"):new()
local data = reader("./05_data.txt")

local max = 0
for _, v in ipairs(data) do
  local line = tostring(v)
  local offset = 128
  local col = 0
  local row = 0
  for c in line:gmatch(".") do
    offset = math.floor(offset/2)
    if(c == "B") then
      col = col + offset
    elseif(c == "R") then
      row = row + offset
    end
    if(1 == offset) then
      -- we are done with offset for colums now, proceed with rows
      offset = 8
    end
  end

  local id = (col * 8) + row
  max = math.max(id, max)
end

print("Maximum seat number is: " .. max)
