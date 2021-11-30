#!/usr/bin/env lua

local reader = require("reader"):new()
local data = reader("./06_data.txt")

local sum_total = 0
local answers = {}

local handle_group_ready = function()
    local sum_group = 0
    for _, _ in pairs(answers) do
      sum_group = sum_group + 1
    end
    sum_total  = sum_total + sum_group
    answers = {}
end

for _, v in ipairs(data) do
  if(tostring(v) == "") then
    handle_group_ready()
  else
    for c in v:gmatch(".") do
      answers[c] = 1
    end
  end
end

-- there is no empty line after the last group
handle_group_ready()

print("Total number of yes-anwers: " .. sum_total)
