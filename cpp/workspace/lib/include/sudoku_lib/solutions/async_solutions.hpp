
#pragma once

#include "sudoku_lib/solutions/isolutions.hpp"

#include "boost/noncopyable.hpp"
#include "boost/scoped_ptr.hpp"

namespace SudokuLib
{
   class AsyncSolutions : public ISolutions,
                          public boost::noncopyable
   {
   public:

      AsyncSolutions(SolutionsPtrT pSolutionsToWrap);

      ~AsyncSolutions();

      virtual void AddSolutions(const SolutionListT& rSolutionList);

   private:

      struct Impl;

      const boost::scoped_ptr<Impl> m_pImpl;
   };
}