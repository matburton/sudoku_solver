
#pragma once

#include "sudoku_lib/types.hpp"

namespace SudokuLib
{
   class ILoader
   {
   public:

      virtual ~ILoader() {};

      virtual PuzzlePtrT GetPuzzle() = 0;
   };

   typedef std::shared_ptr<ILoader> LoaderPtrT;
}