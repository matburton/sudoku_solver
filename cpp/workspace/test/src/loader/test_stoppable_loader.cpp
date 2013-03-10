
#include "sudoku_lib/loader/stoppable_loader.hpp"

#include "boost/test/unit_test.hpp"

//------------------------------------------------------------------------------
namespace
{
   class MockLoader : public SudokuLib::ILoader
   {
   public:

      MockLoader()
         :
         m_bReturnPuzzle(true)
      {}

      virtual SudokuLib::PuzzlePtrT GetPuzzle()
      {
         if (m_bReturnPuzzle)
         {
            m_bReturnPuzzle = false;

            return SudokuLib::PuzzlePtrT(new SudokuLib::PuzzleT);
         }
         else
            return SudokuLib::PuzzlePtrT();
      }

   private:

      bool m_bReturnPuzzle;
   };
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE(StoppableLoader)

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(Constructor)
{
   SudokuLib::LoaderPtrT pNullLoader;

   BOOST_CHECK_THROW(SudokuLib::StoppableLoader stoppableLoader (pNullLoader),
                     std::exception);
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(GetPuzzle)
{
   const SudokuLib::LoaderPtrT pMockLoader (new MockLoader);

   SudokuLib::StoppableLoader stoppableLoader (pMockLoader);

   BOOST_CHECK( stoppableLoader.GetPuzzle());
   BOOST_CHECK(!stoppableLoader.GetPuzzle());
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(Stop)
{
   const SudokuLib::LoaderPtrT pMockLoader (new MockLoader);

   SudokuLib::StoppableLoader stoppableLoader (pMockLoader);

   stoppableLoader.Stop();

   BOOST_CHECK(!stoppableLoader.GetPuzzle());
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE_END()