
#pragma once

#include "sudoku_lib/loader/iup_front_loader.hpp"

#include "boost/noncopyable.hpp"

#include <queue>

namespace SudokuLib
{
   class ITextFile;

   class TextLoader : public IUpFrontLoader,
                      public boost::noncopyable
   {
   public:

      /// \brief Loads all the puzzles from the given file upon construction
      ///        Throws an exception if any of the puzzles are invalid
      ///        The ITextFile is not required during the TextLoader's lifetime
      TextLoader(ITextFile& rFile);

      virtual PuzzlePtrT GetPuzzle();

      virtual std::size_t GetPuzzleCount() const;

   private:

      std::queue<PuzzlePtrT> m_puzzles;
   };
}