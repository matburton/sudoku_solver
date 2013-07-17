
module SudokuSolver.Core.Batch

open System.Linq

open SudokuSolver.Core.Factory
open SudokuSolver.Core.Print
open SudokuSolver.Core.Solve

let private solutionsFromLine = fromLine >> solutions

/// Returns grid lines representing the
/// first found solution to each line
///
let SolveLines (lines : seq<string>) =

   let solveSingle line =

      let solutions = solutionsFromLine line |> Seq.cache

      match Seq.isEmpty solutions with
      | true  -> failwith "A sudoku had no solution"
      | false -> toLine (Seq.head solutions)

   lines.AsParallel().AsOrdered().Select(solveSingle)

/// Returns an IEnumerable which yields grid lines
/// representing all the solutions to the given line
///
let FindAllSolutionsTo = solutionsFromLine >> Seq.map toLine