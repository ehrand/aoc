#!/usr/bin/env lua

local reader = require("reader"):new()
local data = reader("./03_data.txt")
local tree_symbol = "#"

local offsets = {
  {
    cols = 1,
    rows = 1,
    trees = 0,
  },
  {
    cols = 3,
    rows = 1,
    trees = 0,
  },
  {
    cols = 5,
    rows = 1,
    trees = 0,
  },
  {
    cols = 7,
    rows = 1,
    trees = 0,
  },
  {
    cols = 1,
    rows = 2,
    trees = 0,
  },
}

for _, offset in ipairs(offsets) do
  local trees = 0
  local col = 1
  local row = 1
  while(row <= #data) do
    local found = false
    local line = data[row]
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
    print("Processing [" .. string.format("%03d", row) .. "] ~> [" .. line .. "] - [" ..
      tostring(found) .. "]\t[" .. string.format("%02d", col) .. "] - [" .. string.format("%02d", trees) .. "]")
    col = col + offset.cols
    row = row + offset.rows
  end
  offset.trees = trees
end

print("\n")
local multiplied = 1
for _, o in ipairs(offsets) do
  multiplied = multiplied * o.trees
  print("Encountered trees: [" .. o.cols .. "/" .. o.rows .. "] ~> [" ..
    string.format("%03d", o.trees) .. "]; multiplied = " .. multiplied)
end

