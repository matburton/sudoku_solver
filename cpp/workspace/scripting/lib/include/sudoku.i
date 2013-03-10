
%module sudoku

%{
#include "sudoku_scripting_lib/sudoku.hpp"
%}

%include "exception.i"

%exception
{
   try
   {
      $action
   }
   catch (const std::exception& rException)
   {
      SWIG_exception(SWIG_RuntimeError,
                     rException.what());
   }
}

%include "std_string.i"
%include "std_vector.i"

%template(puzzles) std::vector<std::string>;

%include "sudoku_scripting_lib/types.hpp"
%include "sudoku_scripting_lib/sudoku.hpp"