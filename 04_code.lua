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

local passports_valid = 0
local passports_total = 0
for _, v in ipairs(data) do
  local line = tostring(v)
  if(line == "") then
    -- an empty line separates two password entries (and last line in the file is an empty line)
    passports_total = passports_total + 1
    passport.invalidate()
    print("\n")
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
