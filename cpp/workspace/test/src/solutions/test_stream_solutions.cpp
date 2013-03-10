
#include "sudoku_lib/solutions/stream_solutions.hpp"

#include "boost/test/unit_test.hpp"

#include <sstream>

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE(StreamSolutions)

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(AddSolutions)
{
   SudokuLib::SolutionListT solutions;

   const SudokuLib::ValueT puzzleValues[] =
      {0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0};

   const SudokuLib::ValueT solutionValues[] =
      {4, 3, 2, 1, 0, 4, 3, 2, 1, 0, 4, 3, 2, 1, 0, 4};

   solutions.push_back(SudokuLib::Solution
      (SudokuLib::PuzzleT(puzzleValues, puzzleValues + 16),
       SudokuLib::PuzzleT(solutionValues, solutionValues + 16)));

   solutions.push_back(solutions.front());

   std::ostringstream stringStream;

   SudokuLib::StreamSolutions streamSolutions (stringStream);

   streamSolutions.AddSolutions(solutions);

   BOOST_CHECK_EQUAL(stringStream.str(), "Puzzle:   .1234.1234.1234.\n"
                                         "Solution: 4321.4321.4321.4\n\n"
                                         "Puzzle:   .1234.1234.1234.\n"
                                         "Solution: 4321.4321.4321.4\n\n");
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE_END()