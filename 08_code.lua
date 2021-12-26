#!/usr/bin/env lua


local reader = require("reader"):new()
local commands = reader("./08_data.txt")
local accumulator = 0

local execution = function(idx2correct)
  accumulator = 0
  local idx = 1
  local executed_commands = {}

  while idx <= #commands do
    local line = tostring(commands[idx])
    local operation = line:match("%a+")
    local argument = tonumber(line:match("[+-]%d+"), 10)

    for _, v in pairs(executed_commands) do
      if idx == v.idx then
        print('~> Infinite loop detected!')
        print('~> Current command index is ' .. idx)
        print('~> Current accumulator value is ' .. accumulator)
        return false
      end
    end
    table.insert(executed_commands, {idx = idx, cmd = line})
    if idx == idx2correct then
      if('jmp' == operation) then
        print('~> Changing command [' .. idx .. '] ' .. line)
        operation = 'nop'
      elseif 'nop' == operation then
        print('~> Changing command [' .. idx .. '] ' .. line)
        operation = 'jmp'
      end
    end

    if(operation == 'acc') then
      accumulator = accumulator + argument
    end

    idx = idx + ((operation == 'jmp') and argument or 1)
  end
  return true
end

for i = 1, #commands, 1 do
  if execution(i) then
    print('~> Changing command [' .. i .. '] fixed infinite loop!')
    print('~> Current accumulator value is ' .. accumulator)
    return
  end
end
