-- This class is aimed to be used for reading of numbers from a file.
local reader = {}
reader.new = function(self, object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

---@diagnostic disable-next-line: unused-local
reader.__call = function(self, file_name)
  if(type(file_name) ~= "string") then
    print("Please provide file containing numbers as a string!")
    return
  end

  local file = assert(
    io.open(file_name, "r"),
    "Failed to open file " .. file_name .. " for reading!")
  local lines = file:lines()
  local numbers = {}
  for line in lines do
    table.insert(numbers, line)
  end
  file:close()
  return numbers
end

------------------------------------------------------------------------------------------

return reader
