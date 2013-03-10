
#pragma once

#include "sudoku_lib/solutions/solution.hpp"

#include <list>

namespace SudokuLib
{
   typedef std::list<Solution> SolutionListT;

   class ISolutions
   {
   public:

      virtual ~ISolutions() {};

      virtual void AddSolutions(const SolutionListT& rSolutions) = 0;
   };

   typedef std::shared_ptr<ISolutions> SolutionsPtrT;
}