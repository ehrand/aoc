#!/usr/bin/env lua

local input_data = "./02_data.txt"
local reader = require("reader"):new()
local lines = reader(input_data)
local passwords_count_valid = 0
local passwords_count_total = 0

for _, line in pairs(lines) do
  if(type(line) ~= "string") then
    print("line is not a string!")
    return
  end

  local tmp = line

  print("\n ~> starting: [" .. tmp .. "]")
  local limit_low = tonumber(tmp:gsub("%-%d*.*$", ""), 10)
  tmp = tmp:gsub("^%d*%-", "")
  print("low: [" .. limit_low .. "] ~> [" .. tmp .. "]")

  local limit_high = tonumber(tmp:gsub(" %a: %a*$", ""), 10)
  tmp = tmp:gsub("^%d* ", "")
  print("high: [" .. limit_high .. "] ~> [" .. tmp .. "]")

  local char = tmp:gsub(": %a*$", "")
  tmp = tmp:gsub("^%a: ", "")
  print("char: [" .. char .. "] ~> [" .. tmp .. "]")

  local password = tmp

  local valid = false
  if(password:len() >= limit_high) then
    if(password:sub(limit_low, limit_low) == char) then
      valid = (password:sub(limit_high, limit_high) ~= char)
    else
      valid = (password:sub(limit_high, limit_high) == char)
    end
  end

  if(valid) then
    print("Found valid password: [" .. line .. "]")
    passwords_count_valid = passwords_count_valid + 1
  end
  passwords_count_total = passwords_count_total + 1

end

print("\nPasword statistics : [" .. passwords_count_valid .. "/" .. passwords_count_total .. "]")
