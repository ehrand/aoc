#!/usr/bin/env lua

local reader = require("reader"):new()
local data = reader("./04_data.txt")

local passport = {}
passport.byr = nil
passport.cid = nil
passport.ecl = nil
passport.eyr = nil
passport.hcl = nil
passport.hgt = nil
passport.iyr = nil
passport.pid = nil

passport.invalidate = function()
  passport.byr = nil
  passport.cid = nil
  passport.ecl = nil
  passport.eyr = nil
  passport.hcl = nil
  passport.hgt = nil
  passport.iyr = nil
  passport.pid = nil
end

passport.is_valid = function()
  -- field 'passport.cid' is ignored
  return passport.byr and passport.ecl and passport.hcl and passport.hgt and passport.iyr and passport.pid and passport.eyr or false
end

passport.__newindex = function(t, k, v)
  local valid = true
  if(k == "byr") then
    local year = tostring(v)
    if(year:gsub("%d%d%d%d", ""):len() > 0) then
      valid = false
    elseif(tonumber(year, 10) < 1920) then
      valid = false
    elseif(tonumber(year, 10) > 2002) then
      valid = false
    else
      valid = true
    end
  elseif(k == "iyr") then
    local year = tostring(v)
    if(year:gsub("%d%d%d%d", ""):len() > 0) then
      valid = false
    elseif(tonumber(year, 10) < 2010) then
      valid = false
    elseif(tonumber(year, 10) > 2020) then
      valid = false
    else
      valid = true
    end
  elseif(k == "eyr") then
    local year = tostring(v)
    if(year:gsub("%d%d%d%d", ""):len() > 0) then
      valid = false
    elseif(tonumber(year, 10) < 2020) then
      valid = false
    elseif(tonumber(year, 10) > 2030) then
      valid = false
    else
      valid = true
    end
  elseif(k == "hgt") then
    local height = tonumber(tostring(v):gsub("%a%a$", ""), 10)
    local unit = tostring(v):gsub("^%d*", "")
    if(unit == "cm") then
      if(height < 150) then
        valid = false
      elseif(height > 193) then
        valid = false
      else
        valid = true
      end
    elseif(unit == "in") then
      if(height < 59) then
        valid = false
      elseif(height > 76) then
        valid = false
      else
        valid = true
      end
    else
      valid = false
    end
  elseif(k == "hcl") then
    if(tostring(v):gsub("^#%x%x%x%x%x%x$", ""):len() > 0) then
      valid = false
    else
      valid = true
    end
  elseif(k == "ecl") then
    local color = tostring(v)
    if((color == "amb") or (color == "blu") or (color == "brn") or (color == "gry") or (color == "grn") or (color == "hzl") or (color == "oth")) then
      valid = true
    else
      valid = false
    end
  elseif(k == "pid") then
    local number = tostring(v)
    if(number:gsub("^%d%d%d%d%d%d%d%d%d$", ""):len() > 0) then
      valid = false
    else
      valid = true
    end
  end

  if(true == valid) then
    rawset(t, k, v)
  end
end

setmetatable(passport, passport)

local passports_valid = 0
local passports_total = 0
for _, v in ipairs(data) do
  local line = tostring(v)
  if(line == "") then
    -- an empty line separates two password entries (and last line in the file is an empty line)
    passports_total = passports_total + 1
    passport.invalidate()
  else
    print("Processing entry [" .. line .. "]")
    while(#line > 0) do
      local entry = line:gsub("^.*%s", "")
      line = line:gsub("%s?%w*:[#]?%w*$", "")
      local key = entry:gsub(":.*$", "")
      local val = entry:gsub("^.*:", "")
      passport[key] = val
      if(passport.is_valid()) then
        passports_valid = passports_valid + 1
        print("Valid! " .. passports_valid)
        -- we need to invalidate now to make sure that the next line will not lead to another
        -- incrementation (which would be wrong!)
        passport.invalidate()
      end
    end
  end
end

print("Passports stats: [" .. passports_valid .. "/" .. passports_total .. "]")
