
#pragma once

#include "sudoku_lib/worker/iworker.hpp"

#include "boost/noncopyable.hpp"

struct lua_State;

namespace SudokuLib
{
   class LuaWorker : public IWorker,
                     public boost::noncopyable
   {
   public:

      LuaWorker();

      virtual ~LuaWorker();

      virtual void Process(ILoader&    rLoader,
                           ISolutions& rSolutions);
   private:

      lua_State* m_pLuaState;
   };
}