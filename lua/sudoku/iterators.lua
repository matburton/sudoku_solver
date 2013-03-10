
-- Methods to iterate over a subset of squares in a grid
-- These methods use knowledge of the grids bowles

require "sudoku.submodule"

local floor = math.floor

-- This is a private sub-module and as such
-- I don't feel the need to pollute the 
-- parent module's namespace with this class
submodule(...)

-- Increment the iteration over all squares in a
-- sector, used by the squaresInSector iterator
local function incrementInSector(invariant, state)

   if state.squareX and state.squareY then
      
      local newState = { squareX = state.squareX + 1,
                         squareY = state.squareY }
                         
      local sectorDimension = invariant.grid.m_sectorDimension
                         
      if newState.squareX > sectorDimension then
      
         newState.squareX = 1
         newState.squareY = newState.squareY + 1
         
         if newState.squareY > sectorDimension then
            newState = { squareX = nil, squareY = nil }
         end
      end
      
      local columnIndex = invariant.startX + state.squareX
      local rowIndex    = invariant.startY + state.squareY
              
      return newState,
             invariant.grid.m_rows[rowIndex][columnIndex],
             rowIndex, columnIndex
   end
end

-- A stateless iterator which iterates over every
-- square in the sector to which the given square belongs
function squaresInSector(grid, columnIndex, rowIndex)

   local sectorX = floor((columnIndex - 1) / grid.m_sectorDimension)
   local sectorY = floor((rowIndex    - 1) / grid.m_sectorDimension)

   return incrementInSector,
          { grid   = grid,
            startX = sectorX * grid.m_sectorDimension,
            startY = sectorY * grid.m_sectorDimension },
          { squareX = 1, squareY = 1 }
end
