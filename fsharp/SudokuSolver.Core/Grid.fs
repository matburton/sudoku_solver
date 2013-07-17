
module internal SudokuSolver.Core.Grid

open SudokuSolver.Core.Square

type Row = Square []

type Coord       = int * int
type Coords      = Coord list
type CoordsInCol = Coords []

/// Encapsulates a grid of squares and methods to solve the sudoku
///
type Grid = { Rows            : Row []
              SectorSize      : int
              GridSize        : int
              Indexes         : int list
              AllCoords       : Coord list
              SectorCoordRows : CoordsInCol [] }

/// Returns the square at the given coordinates in the supplied grid
///
let getSquare (colIndex, rowIndex) grid = grid.Rows.[rowIndex].[colIndex]

/// Returns the coordinates within the sector which
/// the square at the given coordinates lives within
///
let getSectorCoordinates (colIndex, rowIndex) grid =

   let sectorColIndex = colIndex / grid.SectorSize
   let sectorRowIndex = rowIndex / grid.SectorSize

   grid.SectorCoordRows.[sectorRowIndex].[sectorColIndex]

/// Returns true if the given func returns true for every square in the grid
///
let private allSquares func grid = grid.Rows |> Array.forall (Array.forall func)

/// Returns true if the sudoku is complete
///
let isComplete = allSquares isComplete

/// Returns true if the sudoku can be completed
///
let isPossible = allSquares isPossible