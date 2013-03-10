
#include "sudoku_lib/solutions/async_solutions.hpp"

#include <condition_variable>
#include <mutex>
#include <thread>

//------------------------------------------------------------------------------
struct SudokuLib::AsyncSolutions::Impl
{
   Impl(SolutionsPtrT pSolutionsToWrap);

   void ConsumeSolutions();

   SolutionListT m_solutionQueue;

   bool m_bShouldStop;

   const SolutionsPtrT m_pSolutions;

   std::mutex m_mutex;

   std::condition_variable m_signal;

   std::thread m_thread;
};

//------------------------------------------------------------------------------
SudokuLib::AsyncSolutions::Impl::Impl(SolutionsPtrT pSolutionsToWrap)
   :
   m_pSolutions (pSolutionsToWrap),
   m_bShouldStop(false)
{}

//------------------------------------------------------------------------------
void SudokuLib::AsyncSolutions::Impl::ConsumeSolutions()
{
   BOOST_ASSERT(m_pSolutions);

   while (true)
   {
      SolutionListT solutionList;

      {
         std::unique_lock<std::mutex> lock (m_mutex);

         while (!m_bShouldStop && m_solutionQueue.empty())
         {
            m_signal.wait(lock);
         }

         if (m_bShouldStop)
            break;

         solutionList.swap(m_solutionQueue);
      }

      m_pSolutions->AddSolutions(solutionList);
   }
}

//------------------------------------------------------------------------------
SudokuLib::AsyncSolutions::AsyncSolutions(SolutionsPtrT pSolutionsToWrap)
   :
   m_pImpl(new Impl(pSolutionsToWrap))
{
   if (!pSolutionsToWrap)
   {
      throw std::invalid_argument("AsyncSolutions cannot wrap NULL solutions");
   }

   std::thread consumerThread (&Impl::ConsumeSolutions, m_pImpl.get());

   m_pImpl->m_thread.swap(consumerThread);
}

//------------------------------------------------------------------------------
SudokuLib::AsyncSolutions::~AsyncSolutions()
{
   BOOST_ASSERT(m_pImpl);

   {
      const std::unique_lock<std::mutex> lock (m_pImpl->m_mutex);

      m_pImpl->m_bShouldStop = true;
   }

   m_pImpl->m_signal.notify_one();

   m_pImpl->m_thread.join();
}

//------------------------------------------------------------------------------
void SudokuLib::AsyncSolutions::AddSolutions(const SolutionListT& rSolutionList)
{
   BOOST_ASSERT(m_pImpl);

   {
      const std::unique_lock<std::mutex> lock (m_pImpl->m_mutex);

      SolutionListT newSolutionQueue (m_pImpl->m_solutionQueue);

      for(const Solution& rSolution : rSolutionList)
      {
         newSolutionQueue.push_back(rSolution);
      }

      m_pImpl->m_solutionQueue.swap(newSolutionQueue);
   }

   m_pImpl->m_signal.notify_one();
}