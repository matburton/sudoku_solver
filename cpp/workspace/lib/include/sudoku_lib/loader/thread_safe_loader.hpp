
#pragma once

#include "sudoku_lib/loader/iloader.hpp"

#include "boost/noncopyable.hpp"
#include "boost/scoped_ptr.hpp"

namespace SudokuLib
{
   class ThreadSafeLoader : public ILoader,
                            public boost::noncopyable
   {
   public:

      ThreadSafeLoader(LoaderPtrT pLoaderToWrap);

      virtual ~ThreadSafeLoader();

      virtual PuzzlePtrT GetPuzzle();

   private:

      struct Impl;

      const boost::scoped_ptr<Impl> m_pImpl;
   };
}