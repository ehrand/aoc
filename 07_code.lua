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
    for chld in line:gmatch("%d* %l* %l* bag[s]?") do
      chld = chld:gsub("%sbag[s]?", "")
      local count = tonumber(chld:match("%d*", 1), 10)
      local id = chld:gsub("%d* ", "", 1)
      print('Children: ' .. count .. '/' .. id)
      while count > 0 do
        table.insert(children, Bag:new({name = id}))
        count = count - 1
      end
      line = line:gsub("%l* %l* bag[s]?[,.] ?", "", 1)
    end
  end
  local bag = Bag:new({name = name, parent = nil, children = children})
  print('Inserting ' .. tostring(bag))
  table.insert(bags, bag)
end

------------------------------------------------------------------------------------------

local add_children_of_to = function(bag_name, t)
  for _, b in pairs(bags) do
    if tostring(bag_name) == b.name then
      for _, c in pairs(b.children) do
        table.insert(t, c.name)
      end
      return true
    end
  end
  return false
end

-- now let us get our bag and all its children and put it in a new container
local bags_summarized = {}
add_children_of_to("shiny gold", bags_summarized)
print('Our bag contains ' .. #bags_summarized)

local something_done = true
while something_done do
  something_done = false
  for k, b in pairs(bags_summarized) do
    if tostring(b) ~= 'processed' then
      add_children_of_to(tostring(b), bags_summarized)
      bags_summarized[k] = 'processed'
      something_done = true
    end
  end
end
print('Our bag contains ' .. #bags_summarized .. ' other bags in total')
