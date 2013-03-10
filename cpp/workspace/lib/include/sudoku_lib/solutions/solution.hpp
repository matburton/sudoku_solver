
#pragma once

#include "sudoku_lib/types.hpp"

namespace SudokuLib
{
   struct Solution
   {
      Solution(const PuzzleT& rPuzzle,
               const PuzzleT& rSolution);

      const PuzzleT m_puzzle;
      const PuzzleT m_solution;
   };
}