
namespace SudokuSolver.Core

open System.Collections.Generic

/// An immutable sudoku
///
type ISudoku =

   /// Returns a sudoku with the square at the given
   /// coordinates set to the supplied value.
   /// Coordinates are zero indexed
   ///
   abstract SetSquareValue : int -> (int * int) -> ISudoku

   /// Returns a lazy enumeration of sudokus which
   /// represent the solutions to this sudoku
   ///
   abstract Solutions : IEnumerable<ISudoku>

   /// Returns a string where each character represents
   /// a square value listed left to right, top to bottom
   ///
   abstract ToLine : string

   /// Returns a string which is a human readable representation of the grid
   ///
   abstract ToString : string