
#include "sudoku_scripting_lib/sudoku.hpp"

#include "sudoku_scripting_lib/loader/vector_source.hpp"
#include "sudoku_scripting_lib/solutions/cache_solutions.hpp"

#include "sudoku_lib/loader/text_loader.hpp"
#include "sudoku_lib/loader/thread_safe_loader.hpp"

#include "sudoku_lib/solutions/thread_safe_solutions.hpp"

#include "sudoku_lib/worker/lua_worker.hpp"
#include "sudoku_lib/worker/thread_worker.hpp"

#include "boost/bind.hpp"

#include <thread>

//------------------------------------------------------------------------------
namespace
{
   bool IsSamePuzzle(const SudokuLib::PuzzleT&  rPuzzle,
                     const SudokuLib::Solution& rSolution)
   {
      return rPuzzle == rSolution.m_puzzle;
   }

   //------------------------------------------------------------------------
   void AddSolutionsInOrder
      (SudokuScriptingLib::PuzzlesT&       rTargetSolutions,
       const SudokuScriptingLib::PuzzlesT& rOriginalPuzzles,
       const SudokuLib::SolutionListT&     rSourceSolutions)
   {
      SudokuScriptingLib::VectorSource vectorSource (rOriginalPuzzles);

      SudokuLib::TextLoader textLoader (vectorSource);

      while (SudokuLib::PuzzlePtrT pPuzzle = textLoader.GetPuzzle())
      {
         const SudokuLib::SolutionListT::const_iterator iter
            (std::find_if(rSourceSolutions.begin(), rSourceSolutions.end(),
                          boost::bind(IsSamePuzzle, boost::cref(*pPuzzle),
                                                    _1)));
         if (iter == rSourceSolutions.end())
         {
            throw new std::logic_error
               (SudokuLib::PuzzleToString(*pPuzzle) + " has no solution");
         }

         rTargetSolutions.push_back
            (SudokuLib::PuzzleToString(iter->m_solution));
      }
   }
}

//------------------------------------------------------------------------------
SudokuScriptingLib::PuzzlesT batchSolve
   (const SudokuScriptingLib::PuzzlesT& rPuzzles)
{
   SudokuScriptingLib::VectorSource vectorSource (rPuzzles);

   const SudokuLib::LoaderPtrT pLoader
      (new SudokuLib::TextLoader(vectorSource));

   SudokuLib::ThreadSafeLoader threadSafeLoader (pLoader);

   const std::shared_ptr<SudokuScriptingLib::CacheSolutions>
      pSolutions (new SudokuScriptingLib::CacheSolutions);

   SudokuLib::ThreadSafeSolutions threadSafeSolutions (pSolutions);

   // Put the worker threads in their own scope so
   // that we wait for them to finish before continuing
   {
      std::list<SudokuLib::WorkerPtrT> workers;

      for (unsigned index = 0;
           index < std::thread::hardware_concurrency();
           ++index)
      {
         const SudokuLib::WorkerPtrT pWorker (new SudokuLib::LuaWorker);

         const SudokuLib::WorkerPtrT pThreadWorker
            (new SudokuLib::ThreadWorker(pWorker));

         pThreadWorker->Process(threadSafeLoader, threadSafeSolutions);

         workers.push_back(pThreadWorker);
      }
   }

   SudokuScriptingLib::PuzzlesT solutions;

   AddSolutionsInOrder(solutions, rPuzzles, pSolutions->GetSolutions());

   return solutions;
}