
#include "sudoku_lib/types.hpp"

#include "boost/foreach.hpp"
#include "boost/lexical_cast.hpp"

#include <stdexcept>

//------------------------------------------------------------------------------
std::string SudokuLib::PuzzleToString(const PuzzleT& rPuzzle)
{
   if (rPuzzle.size() > 81)
   {
      throw std::invalid_argument("Cannot convert a puzzle with dimension"
                                  " greater than nine to a string");
   }

   std::string puzzleString;

   BOOST_FOREACH(const SudokuLib::ValueT& rValue, rPuzzle)
   {
      if (0 == rValue)
      {
         puzzleString += ".";
      }
      else
      {
         puzzleString += boost::lexical_cast<std::string>(rValue);
      }
   }

   return puzzleString;
}