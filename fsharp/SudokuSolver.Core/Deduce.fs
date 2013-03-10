
module internal SudokuSolver.Core.Deduce

open SudokuSolver.Core.Grid
open SudokuSolver.Core.Refine
open SudokuSolver.Core.Square

/// Returns true if the square at the given
/// coordinates doesnt contain the supplied possibility
///
let private squareDoesntHave possibility grid coordinates =

   not (contains possibility (getSquare coordinates grid))

/// Returns true if the square at the given coordinates must be
/// the supplied possibility by inspecting other squares in its row
///
let private mustBeValueByRow possibility grid (colIndex, rowIndex) =
   
   grid.Indexes
   |> List.filter (not << ((=) colIndex))
   |> List.map    (fun index -> index, rowIndex)
   |> List.forall (squareDoesntHave possibility grid)

/// Returns true if the square at the given coordinates must be the
/// supplied possibility by inspecting other squares in its column
///
let private mustBeValueByCol possibility grid (colIndex, rowIndex) =
   
   grid.Indexes
   |> List.filter (not << ((=) rowIndex))
   |> List.map    (fun index -> colIndex, index)
   |> List.forall (squareDoesntHave possibility grid)

/// Returns true if the square at the given coordinates must be the
/// supplied possibility by inspecting other squares in its sector
///
let private mustBeValueBySec possibility grid coordinates =
   
   getSectorCoordinates coordinates grid
   |> List.filter (not << ((=) coordinates))
   |> List.forall (squareDoesntHave possibility grid)

/// Returns the value that the square at the given coordinates must contain
/// or None if a value couldn't be infered or if the square already has a value
///
let private deduceSquareValue grid coordinates =

   let square = getSquare coordinates grid

   let mustBeValue possibility =
         mustBeValueByRow possibility grid coordinates
      || mustBeValueByCol possibility grid coordinates
      || mustBeValueBySec possibility grid coordinates

   match not (isComplete square) && isPossible square with
   | false -> None
   | true  -> Seq.tryFind mustBeValue (getPossibilities square)

/// Returns a grid which possibly is a more complete version
///
let rec makeDeductions grid =

   let rec singleDeductionSweep coordinates grid =
      match coordinates with
      | []          -> None
      | coord::tail -> match deduceSquareValue grid coord with
                       | None       -> singleDeductionSweep tail grid
                       | Some value -> Some (setSquare value coord grid)

   match singleDeductionSweep grid.AllCoords grid with
   | None         -> grid
   | Some newGrid -> makeDeductions newGrid