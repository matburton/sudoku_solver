
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
let private insertEvery value every list =

   let initEvery index item =
      match index % every = 0 && not (index = 0) with
      | false -> [item]
      | true  -> [value; item]

   list
   |> List.mapi initEvery
   |> List.concat

/// Returns a string which is a human readable representation of the grid
///
let toGridString grid =

   let maxValueLength = String.length (string(grid.GridSize))

   let squareLength   = maxValueLength + 2

   let sectorDivider  = String.replicate (squareLength * grid.SectorSize) "-"

   let dividerLine    = String.concat "+" (List.replicate grid.SectorSize
                                                          sectorDivider)
   grid.Rows
   |> Array.map (Array.map toString)
   |> Array.map (Array.map (centerString squareLength))
   |> Array.map Array.toList
   |> Array.map (insertEvery "|" grid.SectorSize)
   |> Array.toList
   |> insertEvery [dividerLine] grid.SectorSize
   |> List.map (String.concat "")
   |> List.map ((+) "\n")
   |> String.concat String.Empty