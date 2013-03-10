
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

      while currentGrid do

         -- Apply further deductions
         deductions.refineGrid(currentGrid)

         if currentGrid:isComplete() then

            yield(currentGrid)

         elseif currentGrid:isPossible() then

            -- Split this grid and add the new
            -- grids to the inspection stack
            local gridSplits = currentGrid:split()

            for dummy, grid in pairs(gridSplits) do

               if grid:isComplete() then

                  yield(grid)

               elseif grid:isPossible() then

                  insert(inspectionStack, grid)
               end
            end
         end

         -- Pop off a new grid to inspect
         currentGrid = remove(inspectionStack)
      end

      return nil
   end)
end