
#include "sudoku_lib/loader/thread_safe_loader.hpp"

#include "boost/test/unit_test.hpp"
#include "boost/optional.hpp"

//------------------------------------------------------------------------------
namespace
{
   class MockLoader : public SudokuLib::ILoader
   {
   public:

      virtual SudokuLib::PuzzlePtrT GetPuzzle()
      {
         if (m_oPuzzle)
         {
            return SudokuLib::PuzzlePtrT
               (new SudokuLib::PuzzleT(*m_oPuzzle));
         }
         else
            return SudokuLib::PuzzlePtrT();
      }

      boost::optional<SudokuLib::PuzzleT> m_oPuzzle;
   };
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE(ThreadSafeLoader)

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(Constructor)
{
   const SudokuLib::LoaderPtrT pNullLoader;

   BOOST_CHECK_THROW(SudokuLib::ThreadSafeLoader loader (pNullLoader),
                     std::exception);
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(GetPuzzle)
{
   {
      const SudokuLib::LoaderPtrT pMockLoader (new MockLoader);

      SudokuLib::ThreadSafeLoader loader (pMockLoader);

      BOOST_CHECK(!loader.GetPuzzle().get());
   }

   {
      const std::shared_ptr<MockLoader> pMockLoader (new MockLoader);

      const SudokuLib::PuzzleT puzzle;

      pMockLoader->m_oPuzzle = puzzle;

      SudokuLib::ThreadSafeLoader loader (pMockLoader);

      BOOST_REQUIRE(loader.GetPuzzle().get());

      BOOST_CHECK(puzzle == *loader.GetPuzzle());
   }
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE_END()