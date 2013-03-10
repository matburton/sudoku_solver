
#pragma once

#include "sudoku_lib/solutions/isolutions.hpp"

#include "boost/noncopyable.hpp"

struct sqlite3;
struct sqlite3_stmt;

namespace SudokuLib
{
   class SqliteSolutions : public ISolutions,
                           public boost::noncopyable
   {
   public:

      SqliteSolutions(const std::string& rFilePath);

      virtual ~SqliteSolutions();

      virtual void AddSolutions(const SolutionListT& rSolutionList);

   private:

      void ThrowLastError();

      void PrepareStatment(sqlite3_stmt*&     rpStatment,
                           const std::string& rSqlStatment);

      void ExecuteStatment(sqlite3_stmt& rStatment);

      sqlite3* m_pDatabase;
   };
}