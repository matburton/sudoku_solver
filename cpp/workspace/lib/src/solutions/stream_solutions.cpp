
#include "sudoku_lib/solutions/stream_solutions.hpp"

//------------------------------------------------------------------------------
SudokuLib::StreamSolutions::StreamSolutions(std::ostream& rStream)
   :
   m_rStream(rStream)
{}

//------------------------------------------------------------------------------
void SudokuLib::StreamSolutions::AddSolutions
   (const SolutionListT& rSolutionList)
{
   for(const Solution& rSolution : rSolutionList)
   {
      const std::string puzzle   (PuzzleToString(rSolution.m_puzzle));
      const std::string solution (PuzzleToString(rSolution.m_solution));

      m_rStream << "Puzzle:   " << puzzle.c_str()   << "\n"
                << "Solution: " << solution.c_str() << "\n\n";
   }
}