
#pragma once

#include <string>

namespace SudokuLib
{
   class ITextFile
   {
   public:

      virtual ~ITextFile() {};

      virtual bool GetLine(std::string& rLine) = 0;
   };
}