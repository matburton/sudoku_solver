
#include "sudoku_lib/loader/text_file.hpp"

#include <stdexcept>

//------------------------------------------------------------------------------
SudokuLib::TextFile::TextFile(const std::string& rFilePath)
{
   m_file.exceptions(std::ifstream::badbit);

   m_file.open(rFilePath.c_str());

   if (!m_file.is_open())
      throw std::runtime_error(("Failed to open " + rFilePath).c_str());
}

//------------------------------------------------------------------------------
SudokuLib::TextFile::~TextFile()
{
   if (m_file.is_open())
      m_file.close();
}

//------------------------------------------------------------------------------
bool SudokuLib::TextFile::GetLine(std::string &rLine)
{
   std::string line;

   if (std::getline(m_file, line))
   {
      rLine = line;

      return true;
   }

   return false;
}