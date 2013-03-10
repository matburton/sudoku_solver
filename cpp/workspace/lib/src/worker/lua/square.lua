
-- Use newPossibilitySquare to create a new square
-- Squares use metatables instead of closures to save
-- time and memory hence you must use the ":" notation
-- and only call methods to avoid corrupting the square

require "sudoku.submodule"

local error        = error
local next         = next
local pairs        = pairs
local setmetatable = setmetatable

local insert = table.insert
local sort   = table.sort

-- This is a private sub-module and as such
-- I don't feel the need to pollute the
-- parent module's namespace with this class
submodule("sudoku.square")

-- The table used to allow all
-- squares to use the same closures
local square_methods = {}

-- The metatable used to allow squares to
-- find methods in the square_methods table
local square_metatable = { __index = square_methods }

-- Remove a given possibility
-- Returns true if the possibility
-- existed before it was removed
function square_methods:removePossibility(possibility)

   local hadPossibility = self.m_possibilities[possibility]

   self.m_possibilities[possibility] = nil

   return hadPossibility
end

-- Returns false if the square
-- has no possible values
function square_methods:isPossible()
   return nil ~= next(self.m_possibilities)
end

-- Returns the single possible value
-- of the square if there is only one
-- otherwise returns nil
function square_methods:getValue()

   local firstValue = next(self.m_possibilities)

   if not firstValue or next(self.m_possibilities,
                             firstValue) then
      return nil
   else
      return firstValue
   end
end

-- Sets this square to have a single possible value
function square_methods:setValue(value)

   if value < 1 or value > self.m_maxPossibility then
      error("value out of possible range")
   end

   self.m_possibilities = {}
   self.m_possibilities[value] = true
end

-- Returns a new copy of this square
function square_methods:clone()

   local square = { m_maxPossibility = self.m_maxPossibility,
                    m_possibilities  = {} }

   -- Copy this squares possible values into the new square
   for possibility in pairs(self.m_possibilities) do
      square.m_possibilities[possibility] = true
   end

   setmetatable(square, square_metatable)

   return square
end

-- Returns the possible
-- values for this square
function square_methods:getPossibilities()

   local possibilities = {}

   for possibility in pairs(self.m_possibilities) do

      insert(possibilities, possibility)
   end

   sort(possibilities)

   return possibilities
end

-- Returns a count of the possible
-- values for this square
function square_methods:getPossibilityCount()

   local possibilityCount = 0

   for dummy in pairs(self.m_possibilities) do
      possibilityCount = possibilityCount + 1
   end

   return possibilityCount
end

-- Create a new possibility square for use in a
-- possibility grid, if maxPossibility = 9 then
-- the square will contain the possibilities 1 to 9
function newPossibilitySquare(maxPossibility)

   local square = { m_maxPossibility = maxPossibility,
                    m_possibilities  = {} }

   -- Populate the table with
   -- the initial possibilities
   for possibility = 1, maxPossibility do
      square.m_possibilities[possibility] = true
   end

   setmetatable(square, square_metatable)

   return square
end