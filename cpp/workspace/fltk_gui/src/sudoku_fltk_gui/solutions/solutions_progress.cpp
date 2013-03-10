
#include "sudoku_fltk_gui/solutions/solutions_progress.hpp"

#include "FL/Fl.H"

#include "boost/lexical_cast.hpp"

//------------------------------------------------------------------------------
SolutionsProgress::SolutionsProgress(int x, int y, int nWidth, int nHeight,
                                     std::size_t nPuzzleCount)
   :
   Fl_Progress     (x, y, nWidth, nHeight),
   m_nPuzzleCount  (nPuzzleCount),
   m_nSolutionCount(0)
{
   maximum(static_cast<float>(m_nPuzzleCount));

   Update();
}

//------------------------------------------------------------------------------
void SolutionsProgress::AddSolutions
   (const SudokuLib::SolutionListT& rSolutionList)
{
   const std::unique_lock<std::mutex> lock (m_mutex);

   m_nSolutionCount += rSolutionList.size();

   Fl::awake(this);
}

//------------------------------------------------------------------------------
void SolutionsProgress::Update()
{
   const std::unique_lock<std::mutex> lock (m_mutex);

   value(static_cast<float>(m_nSolutionCount));

   if (m_nPuzzleCount == m_nSolutionCount)
   {
      selection_color(FL_GREEN);
   }
   else
   {
      selection_color(FL_BLUE);
   }

   const std::string solutionCount
      (boost::lexical_cast<std::string>(m_nSolutionCount));

   const std::string puzzleCount
      (boost::lexical_cast<std::string>(m_nPuzzleCount));

   copy_label(("Solved " + solutionCount + " of " + puzzleCount).c_str());
}