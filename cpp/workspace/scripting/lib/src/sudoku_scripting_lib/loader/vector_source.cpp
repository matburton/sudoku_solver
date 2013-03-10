
#include "sudoku_scripting_lib/loader/vector_source.hpp"

//------------------------------------------------------------------------------
SudokuScriptingLib::VectorSource::VectorSource(const PuzzlesT& rPuzzles)
   :
   m_rPuzzles(rPuzzles),
   m_nIndex(0)
{}

//------------------------------------------------------------------------------
bool SudokuScriptingLib::VectorSource::GetLine(std::string& rLine)
{
   if (m_nIndex < m_rPuzzles.size())
   {
      rLine = m_rPuzzles[m_nIndex];

      ++m_nIndex;

      return true;
   }
   else
      return false;
}