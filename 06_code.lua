#!/usr/bin/env lua

local reader = require("reader"):new()
local data = reader("./06_data.txt")

local sum_total = 0
local answers = {}

local handle_group_ready = function()
    local answers_group = nil
    for _, v in pairs(answers) do
      local answers_single = tostring(v)
      answers_group = answers_group or answers_single
      local answers_common = ""
      for c in answers_single:gmatch(".") do
        if(answers_group:find(c)) then
          answers_common = answers_common .. c
        end
      end
      answers_group = answers_common
    end
    return answers_group:len()
end

for _, v in ipairs(data) do
  if(tostring(v) == "") then
    sum_total = sum_total + handle_group_ready()
    answers = {}
  else
    table.insert(answers, v)
  end
end

-- there is no empty line after the last group
sum_total = sum_total + handle_group_ready()

print("Total number of yes-answers: " .. sum_total)
