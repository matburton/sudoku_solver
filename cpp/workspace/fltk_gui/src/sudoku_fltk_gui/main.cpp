
#include "sudoku_fltk_gui/solutions/solutions_progress.hpp"

#include "sudoku_lib/loader/text_file.hpp"
#include "sudoku_lib/loader/text_loader.hpp"
#include "sudoku_lib/loader/stoppable_loader.hpp"

#include "sudoku_lib/solutions/async_solutions.hpp"
#include "sudoku_lib/solutions/multicast_solutions.hpp"
#include "sudoku_lib/solutions/sqlite_solutions.hpp"

#include "sudoku_lib/worker/lua_worker.hpp"
#include "sudoku_lib/worker/thread_worker.hpp"

#include "FL/Fl.H"
#include "FL/fl_ask.H"
#include "FL/Fl_File_Chooser.H"
#include "FL/Fl_Window.H"

#include <thread>

//------------------------------------------------------------------------------
namespace
{
   std::string GetFilePath(const std::string& rTitle, int nMode)
   {
      Fl_File_Chooser fileChooser (NULL, NULL, nMode, rTitle.c_str());

      fileChooser.preview(false);

      fileChooser.show();

      Fl::run();

      if (fileChooser.value())
      {
         return fileChooser.value();
      }
      else
         return "";
   }
}

//------------------------------------------------------------------------------
int main()
{
   try
   {
      Fl::scheme("plastic");

      const std::string puzzleFile (GetFilePath("Open Sudoku Puzzles File",
                                                Fl_File_Chooser::SINGLE));
      if (puzzleFile.empty())
         return 0;

      SudokuLib::TextFile textFile (puzzleFile);

      const std::shared_ptr<SudokuLib::TextLoader> pLoader
         (new SudokuLib::TextLoader(textFile));

      const std::string databasePath (GetFilePath("Sqlite Solutions Database",
                                                  Fl_File_Chooser::CREATE));
      Fl_Window window (300, 60, "Sudoku Solver");

      window.color(FL_WHITE);

      const std::shared_ptr<SudokuLib::MulticastSolutions>
         pMulticastSolutions (new SudokuLib::MulticastSolutions());

      if (!databasePath.empty())
      {
         pMulticastSolutions->AddConsumer(SudokuLib::SolutionsPtrT
            (new SudokuLib::SqliteSolutions(databasePath)));
      }

      const std::shared_ptr<SolutionsProgress> pSolutionsProgress
         (new SolutionsProgress(5, 5, window.w() - 10, window.h() - 10,
                                pLoader->GetPuzzleCount()));

      pMulticastSolutions->AddConsumer(pSolutionsProgress);

      SudokuLib::AsyncSolutions asyncSolutions (pMulticastSolutions);

      window.show();

      SudokuLib::StoppableLoader stoppableLoader (pLoader);

      std::list<SudokuLib::WorkerPtrT> workers;

      for (unsigned index = 0;
           index < std::thread::hardware_concurrency();
           ++index)
      {
         const SudokuLib::WorkerPtrT pWorker (new SudokuLib::LuaWorker);

         const SudokuLib::WorkerPtrT pThreadWorker
            (new SudokuLib::ThreadWorker(pWorker));

         pThreadWorker->Process(stoppableLoader, asyncSolutions);

         workers.push_back(pThreadWorker);
      }

      Fl::lock();

      while (Fl::wait())
      {
         bool bShouldUpdateProgress (false);

         while (void* pMessage = Fl::thread_message())
         {
            if (pMessage == pSolutionsProgress.get())
               bShouldUpdateProgress = true;
         }

         if (bShouldUpdateProgress)
            pSolutionsProgress->Update();
      }

      window.hide();

      stoppableLoader.Stop();

      return 0;
   }
   catch (std::exception& rException)
   {
      fl_alert(rException.what());

      return 1;
   }
}