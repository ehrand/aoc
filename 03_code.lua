#!/usr/bin/env lua

local reader = require("reader"):new()
local data = reader("./03_data.txt")
local tree_symbol = "#"

local col = 1
local trees = 0
for k, v in pairs(data) do
  local found = false
  local line = tostring(v)
  if(col > line:len()) then
    col = col - line:len()
  end
  if(line:sub(col, col) == tree_symbol) then
    found = true
  else
    found = false
  end
  if(true == found) then
    print("                     1234567890123456789012345678901")
    trees = trees + 1
  end
  print("Processing [" .. string.format("%03d", k) .. "] ~> [" .. line .. "] - [" .. tostring(found) .. "]\t[" .. string.format("%02d", col) .. "] - [" .. string.format("%02d", trees) .. "]")
  col = col + 3
end

print("Encountered trees: " .. trees)
