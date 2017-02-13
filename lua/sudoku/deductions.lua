
-- Methods that apply further rules to a grid to
-- eliminate possibilities without splitting the grid
-- These methods use knowledge of the grids bowles

local iterators = require "sudoku.iterators"

local ipairs = ipairs
local pairs  = pairs

local environment = {}

-- This is a private sub-module and as such
-- I don't feel the need to pollute the 
-- parent module's namespace with this class
_ENV = environment

-- Returns true if the given possibility
-- has to be the value of the given square
local function mustBeValueByRow(row, possibility, targetSquare)
  
   for dummy, square in pairs(row) do
      
      if     square ~= targetSquare
         and square.m_possibilities[possibility] then

         return false
      end         
   end
   
   return true
end

-- Returns true if the given possibility
-- has to be the value of the given square
local function mustBeValueByColumn(rows, possibility,
                                   targetSquare, columnIndex)

   for dummy, row in pairs(rows) do
           
      if     row[columnIndex] ~= targetSquare
         and row[columnIndex].m_possibilities[possibility] then

         return false
      end         
   end
   
   return true
end

-- Returns true if the given possibility
-- has to be the value of the given square
local function mustBeValueBySector(grid, possibility,
                                   rowIndex, columnIndex)

   local targetSquare = grid.m_rows[rowIndex][columnIndex]

   for dummy, square in
      iterators.squaresInSector(grid, columnIndex, rowIndex) do
           
      if     square ~= targetSquare
         and square.m_possibilities[possibility] then

         return false
      end         
   end
   
   return true
end

-- Tries to apply rules to this square to  
-- deduce its value, returns the deduced
-- value or nil if no deduction could be made
local function deduceSquare(grid, rowIndex, columnIndex)
   
   local targetSquare = grid.m_rows[rowIndex][columnIndex]
   
   -- We can't deduce a value for this square if
   -- it's already has a single value or is impossible
   if targetSquare:getValue() or not targetSquare:isPossible() then
      return nil
   end
  
   -- Try each possibility of the given square to
   -- try and find if it must be the squares value
   for index, possibility in ipairs(targetSquare:getPossibilities()) do
   
      -- If one of these returns true we don't try the remaining ones
      if    mustBeValueByRow(grid.m_rows[rowIndex], possibility, targetSquare)
         or mustBeValueByColumn(grid.m_rows, possibility, targetSquare, columnIndex)
         or mustBeValueBySector(grid, possibility, rowIndex, columnIndex) then

         return possibility -- It must be this value!
      end 
   end
   
   return nil
end

-- Applies further rules to a grid
-- to eliminate possibilities
function refineGrid(grid)

   local lastRefinedSquare  = nil -- nil to force at least one complete sweep
   local currentRowIndex    = 1
   local currentColumnIndex = 1
   
   local gridDimension = grid.m_sectorDimension ^ 2
     
   -- Keep looping round all the squares in the grid trying to deduce them
   -- until we have done a complete sweep of the grid without deducing anything
   while not lastRefinedSquare
         or  lastRefinedSquare.rowIndex    ~= currentRowIndex
         or  lastRefinedSquare.columnIndex ~= currentColumnIndex do
              
      -- Try to deduce the current square
      local deducedValue = deduceSquare(grid, currentRowIndex,
                                              currentColumnIndex)
                                              
      if deducedValue then -- Apply the deduced value if we found one
         grid:setSquareValue(currentColumnIndex, currentRowIndex, deducedValue)

         if not grid:isPossible() then -- It's pointless to keep
            break                      -- going if the grid can
         end                           -- no longer be solved
      end

      -- If we managed to deduce a value for this
      -- square then note which square it was
      if not lastRefinedSquare or deducedValue then
         
         lastRefinedSquare = { rowIndex    = currentRowIndex,
                               columnIndex = currentColumnIndex }
      end

      -- Move to the next square in the grid
      if currentColumnIndex < gridDimension then
         
         currentColumnIndex = currentColumnIndex + 1
      else
      
         currentColumnIndex = 1
         
         if currentRowIndex < gridDimension then
            currentRowIndex = currentRowIndex + 1
         else
            currentRowIndex = 1     
         end
      end
   end
end

return environment
