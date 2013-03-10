
#include "sudoku_lib/worker/lua_worker.hpp"

#include "sudoku_lib/loader/iloader.hpp"
#include "sudoku_lib/solutions/isolutions.hpp"

#include "lua.hpp"

#include "boost/foreach.hpp"

#include <stdexcept>

//------------------------------------------------------------------------------
namespace
{
   #include "sudoku.bytecode.c"

   const int Success (0);

   //------------------------------------------------------------------------
   int OnError(lua_State* pLuaState)
   {
      const std::string strError (lua_tostring(pLuaState, -1));

      lua_close(pLuaState);

      throw std::runtime_error(strError);

      return 0;
   }

   //------------------------------------------------------------------------
   /// \brief Takes the given puzzle and leaves a
   ///        coroutine to solve the puzzle on the stack
   lua_State* PuzzleToCoroutine(const SudokuLib::PuzzleT& rPuzzle,
                                lua_State*                pLuaState)
   {
      lua_getglobal(pLuaState, "numbersToCoroutine");

      lua_createtable(pLuaState, rPuzzle.size(), 0);

      for (std::size_t nIndex = 1; nIndex <= rPuzzle.size(); ++nIndex)
      {
         lua_pushnumber(pLuaState, nIndex);

         lua_pushnumber(pLuaState, rPuzzle.at(nIndex - 1));

         lua_settable(pLuaState, -3);
      }

      lua_call(pLuaState, 1, 1);

      return lua_tothread(pLuaState, -1);
   }

   //------------------------------------------------------------------------
   /// \brief Resumes the co-routine and returns the yeilded
   ///        solution or NULL if there are no further solutions
   SudokuLib::PuzzlePtrT GetNextSolution(lua_State* pLuaState)
   {
      const int nCode (lua_resume(pLuaState, 0));

      if (nCode != LUA_YIELD && nCode != Success)
         OnError(pLuaState);

      if (lua_isnil(pLuaState, -1))
         return SudokuLib::PuzzlePtrT();

      lua_getglobal(pLuaState, "gridToNumbers");

      const int nFuncHeight (lua_gettop(pLuaState));

      lua_insert(pLuaState, nFuncHeight - 1);

      lua_call(pLuaState, 1, 1);

      SudokuLib::PuzzlePtrT pSolution (new SudokuLib::PuzzleT);

      const std::size_t nTableSize (lua_objlen(pLuaState, -1));

      for (std::size_t nIndex = 1; nIndex <= nTableSize; ++nIndex)
      {
         lua_pushnumber(pLuaState, nIndex);

         lua_gettable(pLuaState, -2);

         pSolution->push_back(lua_tointeger(pLuaState, -1));

         lua_pop(pLuaState, 1);
      }

      return pSolution;
   }
}

//------------------------------------------------------------------------------
SudokuLib::LuaWorker::LuaWorker()
   :
   m_pLuaState(luaL_newstate())
{
   if (!m_pLuaState)
      throw std::bad_alloc();

   lua_atpanic(m_pLuaState, OnError);

   luaL_openlibs(m_pLuaState);

   const std::size_t nBytecodeSize
      (sizeof(sudoku_bytecode) / sizeof(unsigned char));

   const char* pSudokuBytecode
      (reinterpret_cast<const char*>(sudoku_bytecode));

   if (luaL_loadbuffer(m_pLuaState, pSudokuBytecode,
                       nBytecodeSize, "sudoku") != Success)
   {
      OnError(m_pLuaState);
   }

   lua_call(m_pLuaState, 0, 0);
}

//------------------------------------------------------------------------------
SudokuLib::LuaWorker::~LuaWorker()
{
   lua_close(m_pLuaState);
}

//------------------------------------------------------------------------------
void SudokuLib::LuaWorker::Process(ILoader&    rLoader,
                                   ISolutions& rSolutions)
{
   while (PuzzlePtrT pPuzzle = rLoader.GetPuzzle())
   {
      lua_State* pRoutineState (PuzzleToCoroutine(*pPuzzle, m_pLuaState));

      // Only find a single solution to each puzzle
      if (PuzzlePtrT pSolution = GetNextSolution(pRoutineState))
      {
         SolutionListT solutionList;

         solutionList.push_back(Solution(*pPuzzle, *pSolution));

         rSolutions.AddSolutions(solutionList);
      }

      lua_pop(m_pLuaState, 1); // Remove the thread so it
                               // can be garbage collected
   }
}