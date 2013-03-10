
require "core.submodule"

local ipairs = ipairs
local table  = table

submodule(...)

-- Returns true if the item already
-- exists in the given array
function contains(array, checkForItem)

   for index, item in ipairs(array) do

      if item == checkForItem then

         return true
      end
   end

   return false
end

-- Merges the values in a source
-- array into the target array
function mergeInto(target, source)

   for index, value in ipairs(source) do

      table.insert(target, value)
   end
end

local function noOp() end

-- Merges unique items from a source array into a target array
-- onMerge is called before each merge with the item being merged
-- OnMerge is optional and is a No-op if it isn't specified
function mergeUnique(target, source, onMerge)

   onMerge = onMerge or noOp

   for index, value in ipairs(source) do

      if not contains(target, value) then

         onMerge(value)

         table.insert(target, value)
      end
   end
end

-- Removes all items from the given array
-- for which the functor returns true
function removeIf(array, func)

   for index = #array, 1, -1 do

      if func(array[index]) then

         table.remove(array, index)
      end
   end
end