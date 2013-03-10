
#pragma once

#include "sudoku_lib/solutions/isolutions.hpp"

#include "boost/noncopyable.hpp"
#include "boost/scoped_ptr.hpp"

namespace SudokuLib
{
   class ThreadSafeSolutions : public ISolutions,
                               public boost::noncopyable
   {
   public:

      ThreadSafeSolutions(SolutionsPtrT pSolutionsToWrap);

      virtual ~ThreadSafeSolutions();

      virtual void AddSolutions(const SolutionListT& rSolutionList);

   private:

      struct Impl;

      const boost::scoped_ptr<Impl> m_pImpl;
   };
}