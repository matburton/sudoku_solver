
#pragma once

#include "sudoku_lib/solutions/isolutions.hpp"

namespace SudokuLib
{
   class NullSolutions : public ISolutions
   {
   public:

      virtual void AddSolutions(const SolutionListT& rSolutionList);
   };
}