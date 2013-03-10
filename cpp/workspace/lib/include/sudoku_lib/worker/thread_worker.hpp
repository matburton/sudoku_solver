
#pragma once

#include "sudoku_lib/worker/iworker.hpp"

#include "boost/noncopyable.hpp"
#include "boost/scoped_ptr.hpp"

namespace SudokuLib
{
   class ThreadWorker : public IWorker,
                        public boost::noncopyable
   {
   public:

      ThreadWorker(WorkerPtrT pWorkerToWrap);

      virtual ~ThreadWorker();

      virtual void Process(ILoader&    rLoader,
                           ISolutions& rSolutions);
   private:

      struct Impl;

      const boost::scoped_ptr<Impl> m_pImpl;
   };
}