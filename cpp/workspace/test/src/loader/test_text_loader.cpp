
#include "sudoku_lib/loader/text_loader.hpp"
#include "sudoku_lib/loader/itext_file.hpp"

#include "boost/test/unit_test.hpp"

#include <map>

//------------------------------------------------------------------------------
namespace
{
   class MockTextFile : public SudokuLib::ITextFile
   {
   public:

      virtual bool GetLine(std::string& rLine)
      {
         if (m_strings.empty())
            return false;

         rLine = m_strings.front();

         m_strings.pop();

         return true;
      }

      std::queue<std::string> m_strings;
   };
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE(TextLoader)

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(Constructor)
{
   const std::string strings[] = {"",
                                  "123412341234123",
                                  "12341234123412341",
                                  "123412341234123-",
                                  ".234123412341234"
                                  "2",
                                  "3",
                                  "1234123412341235"};

   for(const std::string& rString : strings)
   {
      MockTextFile textFile;
      textFile.m_strings.push(rString);

      BOOST_CHECK_THROW(SudokuLib::TextLoader textLoader (textFile),
                        std::exception);
   }
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(GetPuzzle)
{
   typedef std::map<const std::string,
                    const SudokuLib::PuzzleT> PuzzleStringMapT;

   PuzzleStringMapT puzzles;

   {
      const SudokuLib::ValueT values[] = {0};
      const SudokuLib::PuzzleT puzzle (values, values + 1);

      puzzles.insert(PuzzleStringMapT::value_type("0", puzzle));
   }

   {
      const SudokuLib::ValueT values[] = {1};
      const SudokuLib::PuzzleT puzzle (values, values + 1);

      puzzles.insert(PuzzleStringMapT::value_type("1", puzzle));
   }

   {
      const SudokuLib::ValueT values[] =
         {0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0};

      const SudokuLib::PuzzleT puzzle (values, values + 16);

      puzzles.insert(PuzzleStringMapT::value_type("1", puzzle));
   }

   {
      const SudokuLib::ValueT values[] =
         {1, 2, 3, 4, 5, 6, 7, 8, 9,
          1, 2, 3, 4, 5, 6, 7, 8, 9,
          1, 2, 3, 4, 5, 6, 7, 8, 9,
          1, 2, 3, 4, 5, 6, 7, 8, 9,
          1, 2, 3, 4, 5, 6, 7, 8, 9,
          1, 2, 3, 4, 5, 6, 7, 8, 9,
          1, 2, 3, 4, 5, 6, 7, 8, 9,
          1, 2, 3, 4, 5, 6, 7, 8, 9,
          1, 2, 3, 4, 5, 6, 7, 8, 9};

      const SudokuLib::PuzzleT puzzle (values, values + 81);

      const std::string oneToNine ("123456789");

      const std::string onToNineNineTimes
         (  oneToNine + oneToNine + oneToNine
          + oneToNine + oneToNine + oneToNine
          + oneToNine + oneToNine + oneToNine);

      puzzles.insert(PuzzleStringMapT::value_type(onToNineNineTimes, puzzle));
   }

   MockTextFile textFile;

   for(const PuzzleStringMapT::value_type& rPair : puzzles)
      textFile.m_strings.push(rPair.first);

   SudokuLib::TextLoader textLoader (textFile);

   for(const PuzzleStringMapT::value_type& rPair : puzzles)
   {
      const SudokuLib::PuzzlePtrT pPuzzle (textLoader.GetPuzzle());

      BOOST_REQUIRE(pPuzzle.get());

      BOOST_CHECK(rPair.second == *pPuzzle);
   }

   BOOST_CHECK(!textLoader.GetPuzzle().get());
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(GetPuzzleCount)
{
   MockTextFile mockTextFile;

   const std::size_t nInitialCount (2);

   for (std::size_t nIndex (0); nIndex < nInitialCount; ++nIndex)
   {
      mockTextFile.m_strings.push("0");
   }

   SudokuLib::TextLoader textLoader (mockTextFile);

   for (std::size_t nCount (nInitialCount); nCount > 0; --nCount)
   {
      BOOST_CHECK_EQUAL(nCount, textLoader.GetPuzzleCount());

      textLoader.GetPuzzle();
   }

   BOOST_CHECK_EQUAL(0, textLoader.GetPuzzleCount());
}

//------------------------------------------------------------------------------
BOOST_AUTO_TEST_SUITE_END()