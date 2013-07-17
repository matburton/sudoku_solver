
module SudokuSolver.Core.Factory

open System

open SudokuSolver.Core
open SudokuSolver.Core.Grid
open SudokuSolver.Core.Print
open SudokuSolver.Core.Refine
open SudokuSolver.Core.Solve
open SudokuSolver.Core.Square

/// Returns a list of tuples with every element
/// of list B paired with every element of list A
/// Order is as follows: [1; 2] and [3; 4]
/// returns [[1; 3]; [2; 3]; [1; 3]; [2; 4]]
///
let rec private permute listA =

   let pairWith list i = List.map (fun j -> j, i) list

   List.map (pairWith listA) >> List.concat

/// Returns the coordinates for each sector in a random access matrix
///
let private getSectorCoords sectorSize =

   let startIndex sectorIndex = sectorSize *  sectorIndex
   let stopIndex  sectorIndex = sectorSize * (sectorIndex + 1) - 1

   let getIndexRange sectorIndex =
      [startIndex sectorIndex .. stopIndex sectorIndex]

   let getColCoords rowIndexes sectorColIndex =
      permute (getIndexRange sectorColIndex) rowIndexes

   let getRowCoords sectorRowIndex =
      let rowIndexes = getIndexRange sectorRowIndex
      Array.init sectorSize (getColCoords rowIndexes)

   Array.init sectorSize getRowCoords

/// Returns a grid of the given sector size
/// with each square containing all possibilities
///
let internal emptyGrid =

   let emptyGrid' sectorSize =

      if sectorSize < 1 then
         failwith "Cannot create a grid with a sector size less than 1"

      let gridSize = sectorSize * sectorSize
      let square   = withPossibilities [1 .. gridSize]
      let row      = Array.create gridSize square
      let indexes  = [0 .. (gridSize - 1)]
      { Rows            = Array.create gridSize row
        SectorSize      = sectorSize
        GridSize        = gridSize
        Indexes         = indexes
        AllCoords       = permute indexes indexes
        SectorCoordRows = getSectorCoords sectorSize }

   let classicEmptyGrid = emptyGrid' 3

   fun sectorSize -> match sectorSize with
                     | 3 -> classicEmptyGrid
                     | _ -> emptyGrid' sectorSize

/// Returns a grid with square values set from a line of square values
/// The line must represent a grid with a sector size of 3 or smaller
///
let internal fromLine line =

   let setSquare grid (char, coord) =
      match char with
      | '.'
      | '0'  -> grid
      | char -> let parsed, value = Int32.TryParse (string char)
                
                match parsed with
                | false -> failwith ("Could not parse " + string char)
                | true  -> setSquare value coord grid
                
   let lineLength      = String.length line
   let floatSectorSize = (float lineLength) ** 0.25

   if not (floatSectorSize = Math.Round floatSectorSize) then

      failwith ("Cannot make a grid with a line of length "
                + string lineLength)

   if floatSectorSize > 3.0 then

      failwith ("Cannot parse a line which would create a "
                + "grid with sector dimension 3 or greater")

   let grid = emptyGrid (int floatSectorSize)
   
   Seq.fold setSquare grid (Seq.zip line grid.AllCoords)

/// Implements the ISudoku interface
///
type private Sudoku (grid) =
   interface ISudoku with

      member this.SetSquareValue value coordinates =

         new Sudoku (setSquare value coordinates grid) :> ISudoku

      member this.Solutions =

         solutions grid
         |> Seq.map (fun grid -> new Sudoku(grid) :> ISudoku)

      member this.ToLine = toLine grid

      member this.ToString = toGridString grid

/// Returns a grid of the given sector size
/// with each square containing all possibilities
///
let EmptyGrid sectorSize = new Sudoku(emptyGrid sectorSize) :> ISudoku

/// Returns a grid with square values set from a line of square values
/// The line must represent a grid with  a sector size of 3 or smaller
///
let FromLine line = new Sudoku(fromLine line) :> ISudoku