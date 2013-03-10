
#include "sudoku_scripting_lib/solutions/cache_solutions.hpp"

#include "boost/foreach.hpp"

//------------------------------------------------------------------------------
void SudokuScriptingLib::CacheSolutions::AddSolutions
   (const SudokuLib::SolutionListT& rSolutions)
{
   BOOST_FOREACH(const SudokuLib::Solution& rSolution, rSolutions)
   {
      m_solutions.push_back(rSolution);
   }
}

//------------------------------------------------------------------------------
const SudokuLib::SolutionListT&
SudokuScriptingLib::CacheSolutions::GetSolutions() const
{
   return m_solutions;
}