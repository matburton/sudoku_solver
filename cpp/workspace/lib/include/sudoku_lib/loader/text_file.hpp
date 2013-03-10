
#pragma once

#include "sudoku_lib/loader/itext_file.hpp"

#include <fstream>

namespace SudokuLib
{
   class TextFile : public ITextFile
   {
   public:

      TextFile(const std::string& rFilePath);

      virtual ~TextFile();

      virtual bool GetLine(std::string& rLine);

   private:

      std::ifstream m_file;
   };
}