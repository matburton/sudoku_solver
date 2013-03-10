
#pragma once

#include <memory>

namespace SudokuLib
{
   class ILoader;
   class ISolutions;

   class IWorker
   {
   public:

      virtual ~IWorker() {};

      virtual void Process(ILoader&    rLoader,
                           ISolutions& rSolutions) = 0;
   };

   typedef std::shared_ptr<IWorker> WorkerPtrT;
}