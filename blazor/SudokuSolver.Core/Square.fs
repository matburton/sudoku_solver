
module internal SudokuSolver.Core.Square

type Possibility = int

/// Encapsulates the remaining possible values of a square in a sudoku
///
type Square = Set<Possibility>

/// Returns value of the square if it has only a 
/// single possibility, otherwise returns None
///
let getValue (square : Square) = match Set.count square with
                                 | 1 -> Some (Set.maxElement square)
                                 | _ -> None

/// Returns true if the given square has only a single possibility
///
let isComplete = getValue >> Option.isSome

/// Returns true if the given square has at least one possibility
///
let isPossible square = not (Set.isEmpty square)

/// Returns a string representing the squares value
///
let toString square = match getValue square with
                      | None       -> "."
                      | Some value -> match value >= 11 with
                                      | false -> string value
                                      | true  -> string ((char ((int 'A') + value - 11)))

/// Returns a square containing the given possibilities
///
let withPossibilities = Set.ofList

/// Returns a square containing only the given value as a possibility
///
let withValue = Set.singleton

/// Returns the number of possibilities in a square
///
let countPossibilities = Set.count

/// Returns the possibilities in a square
///
let getPossibilities square = square

/// Returns true if the square has the given possibility
///
let contains = Set.contains

/// Returns a square with the given possibility removed
///
let remove = Set.remove