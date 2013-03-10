
#include "sudoku_lib/types.hpp"

#include "boost/test/unit_test.hpp"

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE(Types)

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(PuzzleToString)
{
   {
      SudokuLib::PuzzleT puzzle;

      puzzle.resize(82);

      BOOST_CHECK_THROW(SudokuLib::PuzzleToString(puzzle), std::exception);
   }

   {
      const SudokuLib::ValueT puzzleValues[] =
         {0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0};

      const SudokuLib::PuzzleT puzzle (puzzleValues, puzzleValues + 16);

      BOOST_CHECK_EQUAL(SudokuLib::PuzzleToString(puzzle), ".1234.1234.1234.");
   }
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE_END()