
#include "sudoku_lib/solutions/sqlite_solutions.hpp"

#include "sqlite3.h"

#include "boost/format.hpp"

#include <stdexcept>

//------------------------------------------------------------------------------
namespace
{
   struct ExceptionSafeStatment : public boost::noncopyable
   {
      ExceptionSafeStatment()
         :
         m_pStatment(NULL)
      {}

      ~ExceptionSafeStatment()
      {
         sqlite3_finalize(m_pStatment);
      }

      sqlite3_stmt* m_pStatment;
   };

   class SqliteTransaction : public boost::noncopyable
   {
   public:

      SqliteTransaction(sqlite3* pDatabase)
         :
         m_pDatabase (pDatabase),
         m_bCommitted(false)
      {
         if (sqlite3_exec(m_pDatabase, "BEGIN", NULL, NULL, NULL) != SQLITE_OK)
         {
            throw std::runtime_error("Could not begin sqlite transaction");
         }
      }

      ~SqliteTransaction()
      {
         if (!m_bCommitted)
            sqlite3_exec(m_pDatabase, "ROLLBACK", NULL, NULL, NULL);
      }

      void Commit()
      {
         if (sqlite3_exec(m_pDatabase, "COMMIT", NULL, NULL, NULL) != SQLITE_OK)
         {
            throw std::runtime_error("Could not commit sqlite transaction");
         }

         m_bCommitted = true;
      }

   private:

      sqlite3* m_pDatabase;

      bool m_bCommitted;
   };

   const int NullTerminatedStr (-1);
}

//------------------------------------------------------------------------------
SudokuLib::SqliteSolutions::SqliteSolutions(const std::string& rFilePath)
   :
   m_pDatabase(NULL)
{
   if (sqlite3_open(rFilePath.c_str(), &m_pDatabase) != SQLITE_OK)
   {
      ThrowLastError();
   }

   const std::string sqlStatment
      ("CREATE TABLE IF NOT EXISTS tbl_Solutions (Puzzle"
       " TEXT NOT NULL, Solution TEXT NOT NULL, PRIMARY"
       " KEY (Puzzle, Solution) ON CONFLICT IGNORE)");

   ExceptionSafeStatment statment;

   PrepareStatment(statment.m_pStatment, sqlStatment);

   ExecuteStatment(*statment.m_pStatment);
}

//------------------------------------------------------------------------------
SudokuLib::SqliteSolutions::~SqliteSolutions()
{
   sqlite3_close(m_pDatabase);
}

//------------------------------------------------------------------------------
void SudokuLib::SqliteSolutions::AddSolutions
   (const SolutionListT& rSolutionList)
{
   SqliteTransaction sqliteTransaction (m_pDatabase);

   for(const Solution& rSolution : rSolutionList)
   {
      const std::string sqlStatment
         ("INSERT OR IGNORE INTO tbl_Solutions (Puzzle, Solution) VALUES (?, ?)");

      ExceptionSafeStatment statment;

      PrepareStatment(statment.m_pStatment, sqlStatment);

      const std::string puzzle   (PuzzleToString(rSolution.m_puzzle));
      const std::string solution (PuzzleToString(rSolution.m_solution));

      if (   sqlite3_bind_text(statment.m_pStatment, 1, puzzle.c_str(),
                               NullTerminatedStr, SQLITE_TRANSIENT) != SQLITE_OK
          || sqlite3_bind_text(statment.m_pStatment, 2, solution.c_str(),
                               NullTerminatedStr, SQLITE_TRANSIENT) != SQLITE_OK)
      {
         ThrowLastError();
      }

      ExecuteStatment(*statment.m_pStatment);
   }

   sqliteTransaction.Commit();
}

//------------------------------------------------------------------------------
void SudokuLib::SqliteSolutions::ThrowLastError()
{
   const int errorCode (sqlite3_errcode(m_pDatabase));

   const std::string error (sqlite3_errmsg(m_pDatabase));

   sqlite3_close(m_pDatabase);

   m_pDatabase = NULL;

   boost::format exceptionMessage ("Error %1%: %2%");

   exceptionMessage % errorCode % error;

   throw std::runtime_error(exceptionMessage.str().c_str());
}

//------------------------------------------------------------------------------
void SudokuLib::SqliteSolutions::PrepareStatment
   (sqlite3_stmt*& rpStatment, const std::string& rSqlStatment)
{
   const char* IgnoreUnusedText (NULL);

   if (sqlite3_prepare(m_pDatabase, rSqlStatment.c_str(), NullTerminatedStr,
                       &rpStatment, &IgnoreUnusedText) != SQLITE_OK)
   {
      ThrowLastError();
   }
}

//------------------------------------------------------------------------------
void SudokuLib::SqliteSolutions::ExecuteStatment(sqlite3_stmt& rStatment)
{
   if (sqlite3_step(&rStatment) != SQLITE_DONE)
   {
      ThrowLastError();
   }
}