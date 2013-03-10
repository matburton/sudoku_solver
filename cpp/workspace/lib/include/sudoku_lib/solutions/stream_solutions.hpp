
#pragma once

#include "sudoku_lib/solutions/isolutions.hpp"

#include <ostream>

namespace SudokuLib
{
   class StreamSolutions : public ISolutions
   {
   public:

      StreamSolutions(std::ostream& rStream);

      virtual void AddSolutions(const SolutionListT& rSolutionList);

   private:

      std::ostream& m_rStream;
   };
}