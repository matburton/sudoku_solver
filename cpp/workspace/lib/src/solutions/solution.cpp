
#include "sudoku_lib/solutions/solution.hpp"

//------------------------------------------------------------------------------
SudokuLib::Solution::Solution(const PuzzleT& rPuzzle,
                              const PuzzleT& rSolution)
   :
   m_puzzle  (rPuzzle),
   m_solution(rSolution)
{}