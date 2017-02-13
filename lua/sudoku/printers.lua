
-- Contains the methods used to print a sudoku grid
-- These methods use knowledge of the grids bowles

local ipairs = ipairs

local concat = table.concat
local insert = table.insert
local len    = string.len
local floor  = math.floor
local ceil   = math.ceil

sudoku = sudoku or {}

_ENV = sudoku

-- Returns a line to divide the
-- rows in different sectors
local function getDividerLine(sectorDimension)

   local maxValueLength = len(floor(sectorDimension ^ 2))

   local charDivider   = "-"
   local sectorDivider = charDivider:rep(  sectorDimension
                                         * (maxValueLength + 2))
   local dividerLine = {}
   for sectorIndex=1, sectorDimension do
      insert(dividerLine, sectorDivider)
   end
   
   return concat(dividerLine, "+")
end

-- Returns the current state of the grid as a string
function getGridString(grid)

   local maxValueLength = len(floor(grid.m_sectorDimension ^ 2))
   
   local dividerLine = getDividerLine(grid.m_sectorDimension)
   
   local gridString = {}

   -- Print each row in order
   for rowIndex, row in ipairs(grid.m_rows) do
   
      local line = {}
   
      -- Print a divider if we went over a sector
      if     rowIndex ~= 1
         and rowIndex % grid.m_sectorDimension == 1 then
         
         insert(gridString, dividerLine)
      end
      
      -- Print the value of each
      -- square on the row in order
      for columnIndex, square in ipairs(row) do
         
         -- Print a divider if we went over a sector
         if     columnIndex ~= 1
            and columnIndex % grid.m_sectorDimension == 1 then
            
            insert(line, "|")
         end
         
         local value = square:getValue() or "."
         
         local space = " "
         local spacesEitherSide = (maxValueLength - len(value)) / 2
         
         insert(line, space:rep(ceil(spacesEitherSide)  + 1))
         insert(line, value)
         insert(line, space:rep(floor(spacesEitherSide) + 1))
      end
      
      insert(gridString, concat(line))
   end
   
   return concat(gridString, "\n")
end

-- Returns the current state of the
-- grid as a line of charcters
function getStateLine(grid)

   if grid.m_sectorDimension > 3 then
      error("Cannot sensibly express such a large grid as a line")
   end

   local line = {}
   
   for rowIndex, row in ipairs(grid.m_rows) do
   
      for columnIndex, square in ipairs(row) do
   
         insert(line, square:getValue() or ".")
      end
   end
   
   return concat(line)
end
