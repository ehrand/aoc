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
  local limit_low = tmp:gsub("%-%d*.*$", "")
  tmp = tmp:gsub("^%d*%-", "")
  print("low: [" .. limit_low .. "] ~> [" .. tmp .. "]")

  local limit_high = tmp:gsub(" %a: %a*$", "")
  tmp = tmp:gsub("^%d* ", "")
  print("high: [" .. limit_high .. "] ~> [" .. tmp .. "]")

  local char = tmp:gsub(": %a*$", "")
  tmp = tmp:gsub("^%a: ", "")
  print("char: [" .. char .. "] ~> [" .. tmp .. "]")

  local password = tmp

  local occurrences = 0
  for i = 1, password:len() do
    if(password:sub(i, i)  == char) then
      occurrences = occurrences + 1
    end
  end
  print("occurrences: " .. occurrences)

  if(occurrences <= tonumber(limit_high)) and (occurrences >= tonumber(limit_low)) then
    print("Found valid password: [" .. line .. "]")
    passwords_count_valid = passwords_count_valid + 1
  end
  passwords_count_total = passwords_count_total + 1

end

print("\nPasword statistics : [" .. passwords_count_valid .. "/" .. passwords_count_total .. "]")
