
#pragma once

#include "sudoku_lib/loader/itext_file.hpp"

#include "sudoku_scripting_lib/types.hpp"

namespace SudokuScriptingLib
{
   class VectorSource : public SudokuLib::ITextFile
   {
   public:

      VectorSource(const PuzzlesT& rPuzzles);

      virtual bool GetLine(std::string& rLine);

   private:

      const PuzzlesT& m_rPuzzles;

      std::size_t m_nIndex;
   };
}