
#include "sudoku_lib/solutions/thread_safe_solutions.hpp"

#include <mutex>

//------------------------------------------------------------------------------
struct SudokuLib::ThreadSafeSolutions::Impl
{
   Impl(SolutionsPtrT pSolutionsToWrap)
      :
      m_pSolutions(pSolutionsToWrap)
   {}

   const SolutionsPtrT m_pSolutions;

   std::mutex m_mutex;
};

//------------------------------------------------------------------------------
SudokuLib::ThreadSafeSolutions::ThreadSafeSolutions
   (SolutionsPtrT pSolutionsToWrap)
   :
   m_pImpl(new Impl(pSolutionsToWrap))
{
   if (!m_pImpl->m_pSolutions)
   {
      throw std::invalid_argument
         ("ThreadSafeSolutions cannot wrap null solutions");
   }
}

//------------------------------------------------------------------------------
SudokuLib::ThreadSafeSolutions::~ThreadSafeSolutions()
{
   // A destructor must be implemented for the smart
   // pointer to correctly delete the pimpl object
}

//------------------------------------------------------------------------------
void SudokuLib::ThreadSafeSolutions::AddSolutions
   (const SolutionListT& rSolutionList)
{
   BOOST_ASSERT(m_pImpl);
   BOOST_ASSERT(m_pImpl->m_pSolutions);

   const std::unique_lock<std::mutex> lock (m_pImpl->m_mutex);

   return m_pImpl->m_pSolutions->AddSolutions(rSolutionList);
}