
#include "sudoku_lib/solutions/thread_safe_solutions.hpp"

#include "boost/test/unit_test.hpp"
#include "boost/optional.hpp"

//------------------------------------------------------------------------------
namespace
{
   class MockSolutions : public SudokuLib::ISolutions
   {
   public:

      MockSolutions()
         :
         m_pSolutionList(NULL)
      {}

      virtual void AddSolutions(const SudokuLib::SolutionListT& rSolutionList)
      {
         if (m_pSolutionList)
         {
            BOOST_FAIL("AddSolutions called more than once");
         }

         m_pSolutionList = &rSolutionList;
      }

      const SudokuLib::SolutionListT* m_pSolutionList;
   };
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE(ThreadSafeSolutions)

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(Constructor)
{
   const SudokuLib::SolutionsPtrT pNullSolutions;

   BOOST_CHECK_THROW(SudokuLib::ThreadSafeSolutions solutions (pNullSolutions),
                     std::exception);
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(AddSolutions)
{
   const SudokuLib::SolutionListT solutions;

   const std::shared_ptr<MockSolutions> pMockSolutions (new MockSolutions);

   SudokuLib::ThreadSafeSolutions threadSafeSolutions (pMockSolutions);

   BOOST_CHECK(!pMockSolutions->m_pSolutionList);

   threadSafeSolutions.AddSolutions(solutions);

   BOOST_REQUIRE(pMockSolutions->m_pSolutionList);

   BOOST_CHECK_EQUAL(&solutions, pMockSolutions->m_pSolutionList);
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE_END()