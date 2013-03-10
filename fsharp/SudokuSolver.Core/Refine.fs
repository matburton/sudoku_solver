
module internal SudokuSolver.Core.Refine

open SudokuSolver.Core.Grid
open SudokuSolver.Core.Square

/// Returns a grid with the square at the given
/// coordinates replaced with the given square
///
let private replaceSquare square (colIndex, rowIndex) grid =

   let replacementArray item index array = let newArray = Array.copy array
                                           Array.set newArray index item
                                           newArray

   let newRow = replacementArray square colIndex grid.Rows.[rowIndex]

   { grid with Rows = replacementArray newRow rowIndex grid.Rows }

/// Remove the given possibility from the square at the supplied
/// coordinates and eliminate possibilities from other squares where feasible
///
let rec private removePossibility possibility grid coordinates =

   let square = getSquare coordinates grid

   match contains possibility square with
   | false -> grid
   | true  -> let newSquare = remove possibility square
              let newGrid = replaceSquare newSquare coordinates grid
              
              match getValue newSquare with
              | None       -> newGrid
              | Some value -> removeRelated value coordinates newGrid

/// Removes the given possibility from squares related to the
/// one at the given coordinates missing only that exact square
///
and private removeRelated possibility coordinates grid =

   grid
   |> removeRowRelated possibility coordinates
   |> removeColRelated possibility coordinates
   |> removeSecRelated possibility coordinates

/// Removes the given possibility from squares in the row 
/// related to the square at the supplied coordinates
///
and private removeRowRelated possibility (colIndex, rowIndex) grid =

   grid.Indexes
   |> List.filter (not << ((=) colIndex))
   |> List.map    (fun index -> index, rowIndex)
   |> List.fold   (removePossibility possibility) grid

/// Removes the given possibility from squares in the column 
/// related to the square at the supplied coordinates
///
and private removeColRelated possibility (colIndex, rowIndex) grid =

   grid.Indexes
   |> List.filter (not << ((=) rowIndex))
   |> List.map    (fun index -> colIndex, index)
   |> List.fold   (removePossibility possibility) grid

/// Removes the given possibility from squares in the sector 
/// related to the square at the supplied coordinates
///
and private removeSecRelated possibility coordinates grid =

   getSectorCoordinates coordinates grid
   |> List.filter (not << ((=) coordinates))
   |> List.fold   (removePossibility possibility) grid

/// Returns a grid with the square at the given
/// coordinates set to the supplied value
///
let setSquare value coordinates grid =

   if value < 1 || value > grid.GridSize then

      failwith "Invalid square value"

   if    fst coordinates < 0 || fst coordinates >= grid.GridSize
      || snd coordinates < 0 || snd coordinates >= grid.GridSize then

      failwith "Invalid grid coordinates"
   
   grid
   |> replaceSquare (withValue value) coordinates
   |> removeRelated value coordinates