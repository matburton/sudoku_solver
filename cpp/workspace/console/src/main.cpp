
#include "sudoku_lib/loader/text_file.hpp"
#include "sudoku_lib/loader/text_loader.hpp"
#include "sudoku_lib/loader/thread_safe_loader.hpp"

#include "sudoku_lib/solutions/stream_solutions.hpp"
#include "sudoku_lib/solutions/thread_safe_solutions.hpp"

#include "sudoku_lib/worker/lua_worker.hpp"
#include "sudoku_lib/worker/thread_worker.hpp"

#include <iostream>
#include <thread>

//------------------------------------------------------------------------------
int main()
{
   try
   {
      SudokuLib::TextFile textFile ("puzzles.txt");

      const SudokuLib::LoaderPtrT pLoader (new SudokuLib::TextLoader(textFile));

      SudokuLib::ThreadSafeLoader threadSafeLoader (pLoader);

      const SudokuLib::SolutionsPtrT pSolutions
         (new SudokuLib::StreamSolutions(std::cout));

      SudokuLib::ThreadSafeSolutions threadSafeSolutions (pSolutions);

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

      return 0;
   }
   catch (std::exception& rException)
   {
      std::cout << "Fatal exception: "
                << rException.what() << std::endl;

      return 1;
   }
}