
#pragma once

#include "sudoku_lib/loader/iloader.hpp"

namespace SudokuLib
{
   class IUpFrontLoader : public ILoader
   {
   public:

      virtual PuzzlePtrT GetPuzzle() = 0;

      /// \brief Returns the number of puzzles remaining
      virtual std::size_t GetPuzzleCount() const = 0;
   };
}