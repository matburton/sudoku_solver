
#include "sudoku_lib/solutions/multicast_solutions.hpp"

#include "boost/assert.hpp"

#include <stdexcept>

//------------------------------------------------------------------------------
void SudokuLib::MulticastSolutions::AddSolutions
   (const SolutionListT& rSolutionList)
{
   for(const SolutionsPtrT pSolutions : m_solutions)
   {
      BOOST_ASSERT(pSolutions);

      pSolutions->AddSolutions(rSolutionList);
   }
}

//------------------------------------------------------------------------------
void SudokuLib::MulticastSolutions::AddConsumer(SolutionsPtrT pSolutions)
{
   if (!pSolutions)
   {
      throw std::invalid_argument
         ("MulticastSolutions cannot add null solution consumer");
   }

   m_solutions.push_back(pSolutions);
}