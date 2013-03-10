
#pragma once

#include "sudoku_lib/solutions/isolutions.hpp"

#include "boost/noncopyable.hpp"

#include <list>

namespace SudokuLib
{
   class MulticastSolutions : public ISolutions,
                              public boost::noncopyable
   {
   public:

      virtual void AddSolutions(const SolutionListT& rSolutionList);

      void AddConsumer(SolutionsPtrT pSolutions);

   private:

      std::list<SolutionsPtrT> m_solutions;
   };
}