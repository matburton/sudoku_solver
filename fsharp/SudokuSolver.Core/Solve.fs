
module internal SudokuSolver.Core.Solve

open SudokuSolver.Core.Deduce
open SudokuSolver.Core.Grid
open SudokuSolver.Core.Split

/// Returns a sequence that finds solutions to a grid
//
let solutions grid =

   let rec solutions' grids = seq {
      
      match grids with
      | []         -> yield! []
      | grid::tail -> let grid = makeDeductions grid

                      if isComplete grid then

                         yield  grid
                         yield! (solutions' tail)

                      else if isPossible grid then

                         let complete, incomplete =
                            split grid
                            |> List.partition isComplete

                         yield! complete
                         yield! (solutions' (List.append incomplete tail))

                      else yield! (solutions' tail)
   }
   
   solutions' [grid]