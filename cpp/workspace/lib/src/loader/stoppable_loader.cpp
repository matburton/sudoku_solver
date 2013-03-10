
#include "sudoku_lib/loader/stoppable_loader.hpp"

#include <mutex>

//------------------------------------------------------------------------------
struct SudokuLib::StoppableLoader::Impl
{
   Impl(LoaderPtrT pLoaderToWrap)
      :
      m_pLoader    (pLoaderToWrap),
      m_bStopCalled(false)
   {}

   const LoaderPtrT m_pLoader;

   bool m_bStopCalled;

   std::mutex m_mutex;
};

//------------------------------------------------------------------------------
SudokuLib::StoppableLoader::StoppableLoader(LoaderPtrT pLoaderToWrap)
   :
   m_pImpl(new Impl(pLoaderToWrap))
{
   if (!m_pImpl->m_pLoader)
      throw std::invalid_argument("StoppableLoader cannot wrap null loader");
}

//------------------------------------------------------------------------------
SudokuLib::StoppableLoader::~StoppableLoader()
{
   // A destructor must be implemented for the smart
   // pointer to correctly delete the pimpl object
}

//------------------------------------------------------------------------------
SudokuLib::PuzzlePtrT
SudokuLib::StoppableLoader::GetPuzzle()
{
   BOOST_ASSERT(m_pImpl);
   BOOST_ASSERT(m_pImpl->m_pLoader);

   const std::unique_lock<std::mutex> lock (m_pImpl->m_mutex);

   if (m_pImpl->m_bStopCalled)
      return PuzzlePtrT();

   return m_pImpl->m_pLoader->GetPuzzle();
}

//------------------------------------------------------------------------------
void SudokuLib::StoppableLoader::Stop()
{
   const std::unique_lock<std::mutex> lock (m_pImpl->m_mutex);

   m_pImpl->m_bStopCalled = true;
}