
#include "sudoku_lib/worker/thread_worker.hpp"

#include "boost/ref.hpp"

#include <thread>

//------------------------------------------------------------------------------
struct SudokuLib::ThreadWorker::Impl
{
   Impl(WorkerPtrT pWorkerToWrap)
      :
      m_pWorker(pWorkerToWrap)
   {}

   const WorkerPtrT m_pWorker;

   std::thread m_thread;
};

//------------------------------------------------------------------------------
SudokuLib::ThreadWorker::ThreadWorker(WorkerPtrT pWorkerToWrap)
   :
   m_pImpl(new Impl(pWorkerToWrap))
{
   if (!m_pImpl->m_pWorker)
   {
      throw std::invalid_argument
         ("ThreadWorker cannot wrap null worker");
   }
}

//------------------------------------------------------------------------------
SudokuLib::ThreadWorker::~ThreadWorker()
{
   BOOST_ASSERT(m_pImpl);

   m_pImpl->m_thread.join();
}

//------------------------------------------------------------------------------
void SudokuLib::ThreadWorker::Process(ILoader&    rLoader,
                                      ISolutions& rSolutions)
{
   BOOST_ASSERT(m_pImpl);
   BOOST_ASSERT(m_pImpl->m_pWorker);

   std::thread newThread (&IWorker::Process, m_pImpl->m_pWorker.get(),
                                             boost::ref(rLoader),
                                             boost::ref(rSolutions));
   m_pImpl->m_thread.swap(newThread);
}