
#include "sudoku_lib/solutions/multicast_solutions.hpp"

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
BOOST_AUTO_TEST_SUITE(MulticastSolutions)

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(AddSolutions)
{
   SudokuLib::MulticastSolutions multicastSolutions;

   const std::shared_ptr<MockSolutions> pMockSolutionsA (new MockSolutions);
   const std::shared_ptr<MockSolutions> pMockSolutionsB (new MockSolutions);

   multicastSolutions.AddConsumer(pMockSolutionsA);
   multicastSolutions.AddConsumer(pMockSolutionsB);

   const SudokuLib::SolutionListT solutions;

   multicastSolutions.AddSolutions(solutions);

   BOOST_REQUIRE(pMockSolutionsA->m_pSolutionList);
   BOOST_REQUIRE(pMockSolutionsB->m_pSolutionList);

   BOOST_CHECK_EQUAL(&solutions, pMockSolutionsA->m_pSolutionList);
   BOOST_CHECK_EQUAL(&solutions, pMockSolutionsB->m_pSolutionList);
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(AddConsumer)
{
   SudokuLib::MulticastSolutions multicastSolutions;

   const SudokuLib::SolutionsPtrT pNullSolutions;

   BOOST_CHECK_THROW(multicastSolutions.AddConsumer(pNullSolutions),
                     std::exception);
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE_END()