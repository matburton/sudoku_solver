
#pragma once

#include "sudoku_lib/loader/iloader.hpp"

#include "boost/noncopyable.hpp"
#include "boost/scoped_ptr.hpp"

namespace SudokuLib
{
   class StoppableLoader : public ILoader,
                           public boost::noncopyable
   {
   public:

      StoppableLoader(LoaderPtrT pLoaderToWrap);

      ~StoppableLoader();

      virtual PuzzlePtrT GetPuzzle();

      void Stop();

   private:

      struct Impl;

      const boost::scoped_ptr<Impl> m_pImpl;
   };
}