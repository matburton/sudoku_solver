
#include "sudoku_lib/loader/thread_safe_loader.hpp"

#include <mutex>

//------------------------------------------------------------------------------
struct SudokuLib::ThreadSafeLoader::Impl
{
   Impl(LoaderPtrT pLoaderToWrap)
      :
      m_pLoader(pLoaderToWrap)
   {}

   const LoaderPtrT m_pLoader;

   std::mutex m_mutex;
};

//------------------------------------------------------------------------------
SudokuLib::ThreadSafeLoader::ThreadSafeLoader(LoaderPtrT pLoaderToWrap)
   :
   m_pImpl(new Impl(pLoaderToWrap))
{
   if (!m_pImpl->m_pLoader)
      throw std::invalid_argument("ThreadSafeLoader cannot wrap null loader");
}

//------------------------------------------------------------------------------
SudokuLib::ThreadSafeLoader::~ThreadSafeLoader()
{
   // A destructor must be implemented for the smart
   // pointer to correctly delete the pimpl object
}

//------------------------------------------------------------------------------
SudokuLib::PuzzlePtrT
SudokuLib::ThreadSafeLoader::GetPuzzle()
{
   BOOST_ASSERT(m_pImpl);
   BOOST_ASSERT(m_pImpl->m_pLoader);

   const std::unique_lock<std::mutex> lock (m_pImpl->m_mutex);

   return m_pImpl->m_pLoader->GetPuzzle();
}