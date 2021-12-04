#!/usr/bin/env lua

local reader = require("reader"):new()
local data = reader("./07_data.txt")

local Bag = {}
Bag.name = nil
Bag.parent = nil
Bag.children = {}

Bag.new = function(self, object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

Bag.__tostring = function(self)
  local str = ""
  if(self.parent) then
    str = str .. "(" .. tostring(self.parent.name) .. ") "
  end
  str = str .. "~> [" .. tostring(self.name) .. "]"
  str = str .. " <~ {-"
  for _, v in pairs(self.children) do
    str = str .. " " .. tostring(v.name) .. " -"
  end
  str = str .. "}"
  return str
end

local bags = {}

------------------------------------------------------------------------------------------

-- plaid teal bags contain no other bags.
-- clear black bags contain 4 dark plum bags.
-- dull salmon bags contain 3 drab white bags, 2 vibrant orange bags.
for _, b in pairs(data) do
  local line = tostring(b)
  print("Processing [" .. line .. "]")
  local children = {}
  local name = line:match("%l* %l*", 1)
  line = line:gsub("%l* %l* bags contain ", "")
  if(line ~= "no other bags.") then
    line = line:gsub("%d%s", "")
    for chld in line:gmatch("%l* %l* bag[s]?") do
      chld = chld:gsub("%sbag[s]?", "")
      line = line:gsub("%l* %l* bag[s]?[,.] ?", "", 1)
      table.insert(children, Bag:new({name = chld}))
    end
  end
  local bag = Bag:new({name = name, parent = nil, children = children})
  table.insert(bags, bag)

end

------------------------------------------------------------------------------------------

local my_bag_containers = {}
local my_bag_name = "shiny gold"
local insert_if_not_available = function(t, e)
  for _, v in pairs(t) do
    if(tostring(v) == tostring(e)) then
      return nil
    end
  end
  table.insert(t, e)
  print("Inserted [" .. tostring(e) .. "]")
  return true
end

-- find all direct parents of my bag
for _, prnt in pairs(bags) do
  for _, chld in pairs(prnt.children) do
    if(chld.name == my_bag_name) then
      insert_if_not_available(my_bag_containers, prnt.name)
    end
  end
end

-- now let's find all the parents of parents and so on...
local going_on = true
while(going_on) do
  going_on = false
  for _, v in pairs(my_bag_containers) do
    for _, prnt in pairs(bags) do
      for _, chld in pairs(prnt.children) do
        if(chld.name == v) then
          local inserted = insert_if_not_available(my_bag_containers, prnt.name)
          going_on = going_on or inserted
        end
      end
    end
  end
end

print("Total container size " .. #my_bag_containers)
