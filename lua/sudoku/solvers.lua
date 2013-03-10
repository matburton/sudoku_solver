
-- This file implements the algorithm needed
-- to find solutions to a sudoku grid

local deductions = require "sudoku.deductions"

local pairs = pairs

local insert = table.insert
local remove = table.remove
local resume = coroutine.resume
local create = coroutine.create
local yield  = coroutine.yield

module("sudoku")

-- Returns a co-routine that finds solutions to a grid
-- Every time it is resumed it returns a solution
function produceSolutions(currentGrid)

   return create(function ()
      
      if not currentGrid:isPossible() then
      
         return nil, 0
      end
      
      -- These are grids that are awaiting
      -- inspection or futher splitting
      local inspectionStack = {}
      
      -- This is the number of grid splits
      -- performed as a measure of difficulty
      local splitsPerformed = 0
            
      while currentGrid do
      
         -- Apply further deductions
         deductions.refineGrid(currentGrid)
         
         if currentGrid:isComplete() then
         
            -- Return the solution and the number
            -- of grid splits performed so far
            yield(currentGrid, splitsPerformed)
            
         elseif currentGrid:isPossible() then
               
            -- Split this grid and add the new
            -- grids to the inspection stack
            local gridSplits = currentGrid:split()
            
            splitsPerformed = splitsPerformed + #gridSplits
            
            for dummy, grid in pairs(gridSplits) do
            
               if grid:isComplete() then
               
                  yield(grid, splitsPerformed)
               
               elseif grid:isPossible() then
            
                  insert(inspectionStack, grid)
               end
            end
         end
            
         -- Pop off a new grid to inspect
         currentGrid = remove(inspectionStack)
      end
      
      return nil, splitsPerformed
   end)
end

-- Returns a single solution to the
-- grid or nil if there is no solution
function findSingleSolution(grid)

   local coroutine = produceSolutions(grid)

   local dummy, solution, splits = resume(coroutine)
   
   return solution, splits
end

-- Returns all the solutions to a grid in an array
-- or an empty array if there were no solutions
function findAllSolutions(grid)

   local coroutine = produceSolutions(grid)
   
   local solutions = {}
   
   local splits = 0
   
   repeat
   
      local dummy, solution
      
      dummy, solution, splits = resume(coroutine)
      
      if solution then
         insert(solutions, solution)
      end
      
   until not solution
   
   return solutions, splits
end
