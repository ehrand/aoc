#!/usr/bin/env lua


local reader = require("reader"):new()
local commands = reader("./08_data.txt")
local accumulator = 0
local executed_commands = {}

local idx = 1
while idx <= #commands do
  local line = tostring(commands[idx])
  local operation = line:match("%a+")
  local argument = tonumber(line:match("[+-]%d+"), 10)

  for _, v in pairs(executed_commands) do
    if idx == v then
      print('~> Infinite loop detected!')
      print('~> Current command index is ' .. idx)
      print('~> Current accumulator value is ' .. accumulator)
      return
    end
  end
  table.insert(executed_commands, idx)

  if(operation == 'acc') then
    accumulator = accumulator + argument
  end

  idx = idx + ((operation == 'jmp') and argument or 1)
end
