
-- Provides a layer between lua and C to minimise the
-- number of stack operations required to solve sudokus

require "sudoku.grid"
require "sudoku.solvers"

-- Given a varible number of numbers, creates a
-- grid and returns a co-routine used to solve it
function numbersToCoroutine(values)

   local valueCount      = #values
   local sectorDimension = valueCount ^ (1/4)

   if math.ceil(sectorDimension) ~= sectorDimension then

      error("Cannot create a grid from "
            .. valueCount .. " values")
   end

   local grid = sudoku.newGrid(sectorDimension)

   local gridDimension = sectorDimension ^ 2

   for index, value in ipairs(values) do

      if value ~= 0 then

         local rowIndex = math.ceil(index / gridDimension)
         local colIndex = index % gridDimension

         if 0 == colIndex then
            colIndex = gridDimension
         end

         grid:setSquareValue(colIndex, rowIndex, value)
      end
   end

   return sudoku.produceSolutions(grid)
end

-- Given a grid returns all the values in
-- the grid and 0 where there is no value
function gridToNumbers(grid)

   local values = {}

   for rowIndex, row in ipairs(grid.m_rows) do

      for colIndex, square in ipairs(row) do

         table.insert(values, square:getValue() or 0)
      end
   end

   return values
end