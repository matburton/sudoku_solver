
#pragma once

#include "sudoku_lib/solutions/isolutions.hpp"

namespace SudokuScriptingLib
{
   class CacheSolutions : public SudokuLib::ISolutions
   {
   public:

      virtual void AddSolutions
         (const SudokuLib::SolutionListT& rSolutions);

      const SudokuLib::SolutionListT& GetSolutions() const;

   private:

      SudokuLib::SolutionListT m_solutions;
   };
}