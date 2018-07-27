
module internal SudokuSolver.Core.Print

open System

open SudokuSolver.Core.Grid
open SudokuSolver.Core.Square

/// Returns a string where each character represents
/// a square value listed left to right, top to bottom
///
let toLine grid =

   if grid.SectorSize > 3 then

      failwith ("Cannot convert a grid with sector"
                + " size greater than 3 to a line")
   grid.Rows
   |> Array.concat
   |> Array.map toString
   |> String.concat String.Empty

/// Returns the given string but centered in
/// spaces such that it's the supplied length
///
let private centerString desiredLength string =

   let stringLength = String.length string

   let spacesEitherSide = float (desiredLength - stringLength) / 2.0

   let spaceUsing func = String.replicate (int (func spacesEitherSide)) " "

   (spaceUsing Math.Ceiling) + string + (spaceUsing Math.Floor)

/// Returns a list with the given value inserted after each 'every' items
///
let rec private insertEvery value every col = seq {

      match Seq.length col <= every with
      | true -> yield! col
      | false-> yield! Seq.take every col
                yield  value
                yield! insertEvery value every (Seq.skip every col)
}

/// Returns a string which is a human readable representation of the grid
///
let toGridString grid =

   let maxValueLength = 1

   let sectorLength = maxValueLength * grid.SectorSize + grid.SectorSize - 1

   let dividerLine = String.replicate sectorLength "-"
                     |> List.replicate grid.SectorSize
                     |> String.concat "-+-"

   let rowToString = Array.map toString
                     >> Array.map (centerString maxValueLength)
                     >> insertEvery "|" grid.SectorSize
                     >> String.concat " "
   grid.Rows
   |> Array.map rowToString
   |> insertEvery dividerLine grid.SectorSize
   |> String.concat "\n"