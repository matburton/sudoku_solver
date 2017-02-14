
#load "../../fsharp/SudokuSolver.Core/Square.fs"
#load "../../fsharp/SudokuSolver.Core/Grid.fs"
#load "../../fsharp/SudokuSolver.Core/Refine.fs"
#load "../../fsharp/SudokuSolver.Core/Deduce.fs"
#load "../../fsharp/SudokuSolver.Core/Split.fs"
#load "../../fsharp/SudokuSolver.Core/Solve.fs"
#load "../../fsharp/SudokuSolver.Core/Print.fs"
#load "../../fsharp/SudokuSolver.Core/ISudoku.fs"
#load "../../fsharp/SudokuSolver.Core/Factory.fs"
#load "../../fsharp/SudokuSolver.Core/Batch.fs"

open System
open System.IO
open System.Linq

open SudokuSolver.Core
open SudokuSolver.Core.Factory
open SudokuSolver.Core.Print
open SudokuSolver.Core.Solve

let private solveAll =

    let solveSingle solutions =
        match Seq.isEmpty solutions with
        | true  -> failwith "Didn't find a solution to a sudoku"
        | false -> Seq.head solutions
        
    let withSolution puzzle =
        (puzzle, solutions puzzle |> Seq.cache |> solveSingle)
        
    use outputFile = File.CreateText("fsharp_results.csv")
        
    let outputLine index (puzzle, solution) =
        printfn "Solved puzzle number %i" index
        printfn "%s\n" (toGridString solution)
        outputFile.WriteLine(sprintf "%s,%s" (toLine puzzle) (toLine solution))

    File.ReadAllLines("puzzles.txt")
        .AsParallel()
        .AsOrdered()
        .Select(fromLine)
        .Select(withSolution)
        |> Seq.iteri outputLine
    
solveAll