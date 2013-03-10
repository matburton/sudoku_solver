
#include "sudoku_lib/loader/text_loader.hpp"

#include "sudoku_lib/loader/itext_file.hpp"

#include "boost/lexical_cast.hpp"

#include <stdexcept>

//------------------------------------------------------------------------------
namespace
{
   /// \brief Returns the sector dimension given a string representing a
   ///        sudoku puzzle or throws an exception if the length of the
   ///        puzzle string prevents it from being a valid sudoku
   std::size_t GetSectorDimension(const std::string& rPuzzleString)
   {
      for (std::size_t nSectorDimension = 1; nSectorDimension <= 3;
           ++nSectorDimension)
      {
         const std::size_t nValuesInSector
            (nSectorDimension * nSectorDimension);

         const std::size_t nValuesInPuzzle
            (nValuesInSector * nValuesInSector);

         if (nValuesInPuzzle == rPuzzleString.size())
            return nSectorDimension;
      }

      throw std::range_error("Puzzle " + rPuzzleString
                             + " has an invalid number of characters");
   }
}

//------------------------------------------------------------------------------
SudokuLib::TextLoader::TextLoader(ITextFile& rFile)
{
   std::string line;

   while (rFile.GetLine(line))
   {
      const std::size_t nSectorDimension (GetSectorDimension(line));

      const std::size_t nMaxValue (nSectorDimension * nSectorDimension);

      PuzzlePtrT pPuzzle (new PuzzleT);

      // Validate and add each character to the puzzle
      for(const char& rChar : line)
      {
         ValueT nValue;

         try
         {
            nValue = boost::lexical_cast<ValueT>(rChar);
         }
         catch (const boost::bad_lexical_cast&)
         {
            throw std::range_error
               (rChar + " is not valid in puzzle " + line);
         }

         if (nValue > nMaxValue)
         {
            throw std::range_error
               (rChar + " is not valid in puzzle " + line);
         }

         pPuzzle->push_back(nValue);
      }

      m_puzzles.push(pPuzzle); // Add the puzzle to the queue
   }
}

//------------------------------------------------------------------------------
SudokuLib::PuzzlePtrT
SudokuLib::TextLoader::GetPuzzle()
{
   if (m_puzzles.empty())
      return PuzzlePtrT();

   PuzzlePtrT pPuzzle (m_puzzles.front());

   m_puzzles.pop();

   return pPuzzle;
}

//------------------------------------------------------------------------------
std::size_t
SudokuLib::TextLoader::GetPuzzleCount() const
{
   return m_puzzles.size();
}