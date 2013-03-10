
#pragma once

#include "sudoku_lib/solutions/isolutions.hpp"

#include "FL/Fl_Progress.H"

#include <mutex>

//------------------------------------------------------------------------------
class SolutionsProgress : public SudokuLib::ISolutions,
                          public Fl_Progress
{
public:

   SolutionsProgress(int x, int y, int nWidth, int nHeight,
                     std::size_t nPuzzleCount);

   virtual void AddSolutions(const SudokuLib::SolutionListT& rSolutionList);

   void Update();

private:

   const std::size_t m_nPuzzleCount;

   std::size_t m_nSolutionCount;

   std::mutex m_mutex;
};