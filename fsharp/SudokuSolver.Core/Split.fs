
module internal SudokuSolver.Core.Split

open SudokuSolver.Core.Grid
open SudokuSolver.Core.Refine
open SudokuSolver.Core.Square

/// Chooses a square that has two or more possibilities
/// and returns a list containing new versions of this
/// grid each with the chosen square containing one of
/// those possibilities
///
let split grid =

   let withPossibilityCount coordinates =
      countPossibilities (getSquare coordinates grid), coordinates

   let coordinatesToSplit = grid.AllCoords
                            |> List.map withPossibilityCount
                            |> List.filter ((<) 1 << fst)
                            |> List.minBy fst
                            |> snd

   getPossibilities (getSquare coordinatesToSplit grid)
   |> Seq.map (fun value -> setSquare value coordinatesToSplit grid)
   |> Seq.toList