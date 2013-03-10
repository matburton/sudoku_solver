
#pragma once

#include <memory>
#include <vector>

namespace SudokuLib
{
   typedef unsigned int ValueT;

   /// \note In retrospect this should have been a class. If it were then the
   ///       validation could have been in its constructor and we would have
   ///       had a guarantee when using the puzzle elsewhere that it is valid
   typedef std::vector<ValueT> PuzzleT;

   typedef std::shared_ptr<PuzzleT> PuzzlePtrT;

   std::string PuzzleToString(const PuzzleT& rPuzzle);
}