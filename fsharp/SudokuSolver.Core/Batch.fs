
module SudokuSolver.Core.Batch

open System.Collections.Generic

open SudokuSolver.Core.Factory
open SudokuSolver.Core.Print
open SudokuSolver.Core.Solve

/// Returns grid lines representing the
/// first found solution to each line
///
let SolveLines lines =

   let solveSingle line =

      let solutions = fromLine line
                      |> solutions
                      |> Seq.cache

      match Seq.isEmpty solutions with
      | true  -> failwith "A sudoku had no solution"
      | false -> toLine (Seq.head solutions)

   Seq.cast lines
   |> Seq.toArray
   |> Array.Parallel.map solveSingle

/// Returns an IEnumerable which yields grid lines
/// representing all the solutions to the given line
///
let FindAllSolutionsTo line = fromLine line
                              |> solutions
                              |> Seq.map toLine