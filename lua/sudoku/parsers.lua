
-- Implements parsing functions to allow grids to be
-- created quickly and easily from another format

require "sudoku.grid"

local sudoku = sudoku

local error    = error
local tonumber = tonumber

local ceil = math.ceil

module("sudoku")

-- Returns a grid with square values
-- set from a line of square values
-- The line must represent a grid with
-- a sector size of 3 or smaller
function parseLine(line)
   
   local lineLength      = line:len()
   local sectorDimension = lineLength ^ (1/4)
   
   -- Check that a grid can be made
   -- from this number of characters
   if ceil(sectorDimension) ~= sectorDimension then
   
      error(lineLength .. " characters is invalid")
      
   elseif sectorDimension > 3 then
   
      error("Sector size would be greater than 3")
   end
     
   local grid = sudoku.newGrid(sectorDimension)
   
   local gridDimension = sectorDimension ^ 2
   
   -- Parse each square value, or character, in turn
   -- and set the appropriate square value on the grid
   for charIndex=1, lineLength do
      
      local currentChar = line:sub(charIndex, charIndex)
      
      if     "." ~= currentChar
         and "0" ~= currentChar then
      
         local currentNum = tonumber(currentChar)
         
         if not currentNum then
            error("Cannot parse " .. currentChar)
         end
               
         local rowIndex    = ceil(charIndex / gridDimension)
         local columnIndex = charIndex % gridDimension
         
         if 0 == columnIndex then
            columnIndex = gridDimension
         end
         
         grid:setSquareValue(columnIndex, rowIndex, currentNum)
      end
   end
   
   return grid
end
