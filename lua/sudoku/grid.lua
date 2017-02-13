
-- Use newGrid to create a new grid
-- Grids use metatables instead of closures to save
-- time and memory hence you must use the ":" notation
-- and only call methods to avoid corrupting the grid

local square    = require "sudoku.square"
local iterators = require "sudoku.iterators"

local error        = error
local ipairs       = ipairs
local pairs        = pairs
local setmetatable = setmetatable

local insert = table.insert

sudoku = sudoku or {}

_ENV = sudoku

-- Forward declare these methods
-- as they use indirect recursion
local removePossibility
local removeRelatedPossibilities

-- Removes a possible value from a
-- square and all 'related' squares
-- if the squares value becomes certain
function removePossibility(grid, x, y, value)
     
   local square = grid.m_rows[y][x]
   
   if square:removePossibility(value) then
           
      local certainValue = square:getValue()
      
      if certainValue then
         removeRelatedPossibilities(grid, x, y, certainValue)
      end         
   end
end
  
-- Remove this possible value from 'related'
-- squares but not the square itself
function removeRelatedPossibilities(grid, x, y, value)
      
   local targetSquare = grid.m_rows[y][x]

   -- Start with the square's row
   for columnIndex, square in pairs(grid.m_rows[y]) do
      if square ~= targetSquare then
         removePossibility(grid, columnIndex, y, value)
      end
   end
         
   -- Then squares that are in the same column
   for rowIndex, row in pairs(grid.m_rows) do
      if row[x] ~= targetSquare then
         removePossibility(grid, x, rowIndex, value)
      end         
   end
     
   -- Then squares that are in the same sector
   for dummy, square, rowIndex, columnIndex
      in iterators.squaresInSector(grid, x, y) do
            
      if square ~= targetSquare then
         removePossibility(grid, columnIndex, rowIndex, value)
      end
   end
end

-- The table used to allow all 
-- grids to use the same closures
local grid_methods = {}

-- The metatable used to allow grids to
-- find methods in the grid_methods table
local grid_metatable = { __index = grid_methods }

-- Sets a square to have a single possibility
function grid_methods:setSquareValue(x, y, value)
     
   if not self.m_rows[y] then
      error("row doesn't exist")
   elseif not self.m_rows[y][x] then
      error("column doesn't exist")
   end
        
   self.m_rows[y][x]:setValue(value)
   
   removeRelatedPossibilities(self, x, y, value)
end

-- Returns true if every square still
-- has at least one possible value
function grid_methods:isPossible()

   for rowIndex, row in pairs(self.m_rows) do
   
      for columnIndex, square in pairs(row) do
      
         if not square:isPossible() then
            return false
         end
      end
   end
   
   return true
end

-- Returns true if every square has
-- only a single possible value
function grid_methods:isComplete()
   
   for rowIndex, row in pairs(self.m_rows) do
   
      for columnIndex, square in pairs(row) do
      
         if not square:getValue() then
            return false
         end
      end
   end
   
   return true      
end

-- Creates a new copy of the given grid
function clone(grid)
   
   -- Create the actual grid state
   local newGrid = { m_rows            = {},
                     m_sectorDimension = grid.m_sectorDimension }
   
   -- Copy the squares in the grid   
   for rowIndex, row in pairs(grid.m_rows) do
      
      newGrid.m_rows[rowIndex] = {}
      
      for columnIndex, square in pairs(row) do
         newGrid.m_rows[rowIndex][columnIndex] = square:clone()
      end
   end
                  
   setmetatable(newGrid, grid_metatable)
                  
   return newGrid
end

-- Chooses a square that has two or more possibilities
-- and returns an array containing new versions of this
-- grid each with the chosen square containing one of
-- those possibilities. If there were no viable squares
-- to split then nil is returned
function grid_methods:split()

   local squareToSplit
   
   -- Find the square with the least possibilities that can be split 
   for rowIndex, row in pairs(self.m_rows) do
   
      for columnIndex, square in pairs(row) do
   
         if not square:getValue()
            and square:isPossible() then
            
            local squareCount = square:getPossibilityCount()
            
            if not squareToSplit
               or  squareCount <
                   squareToSplit.possibilityCount then
               
               squareToSplit = { square           = square,
                                 rowIndex         = rowIndex,
                                 columnIndex      = columnIndex,
                                 possibilityCount = squareCount }
            end
         end
      end
   end
   
   if squareToSplit then
     
      local splitGrids = {}
      
      -- Clone the grid for each of the possibilities in
      -- the square to split and then set the related square's
      -- value in the cloned grid to one of those possibilities
   
      for index, possibility in
          ipairs(squareToSplit.square:getPossibilities()) do
          
         local newGrid = clone(self)
         
         newGrid:setSquareValue(squareToSplit.columnIndex,
                                squareToSplit.rowIndex,
                                possibility)
         
         insert(splitGrids, newGrid)
      end
      
      return splitGrids
   end
   
   return nil
end

-- Creates a sudoku grid with the given sector
-- dimenions, so the width of the grid will be
-- this value squared and the total number of
-- squares will be this value pow'd by four
-- Each square starts with all possible values
function newGrid(sectorDimension)

   -- Check the grid size is possible
   if sectorDimension < 1 then
      error("sector size must be greater than zero")
   end
   
   -- Create the actual grid state
   local grid = { m_rows            = {},
                  m_sectorDimension = sectorDimension }
   
   local gridDimension = sectorDimension ^ 2
   
   -- Add the rows to the rows table and populate
   -- each row with the possibility squares
   for rowIndex = 1, gridDimension do
   
      grid.m_rows[rowIndex] = {}
           
      for columnIndex = 1, gridDimension do
      
         grid.m_rows[rowIndex][columnIndex] = 
            square.newPossibilitySquare(gridDimension)
      end
   end
   
   setmetatable(grid, grid_metatable)
   
   return grid
end
