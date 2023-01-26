
using Megaprocessor.Reference.SudokuSolver;

var harness = new Harness(() => new OriginalSolver(),
                          () => new SuppressedRefineSolver
                                        { EnableUponCompleteSquareCount = 10 });
var puzzles = File
    .ReadAllLines(@"../../../../../puzzles/sudoku17/puzzles.txt")
    .Take(20_000)
    .Select(Parser.FromLine)
    .ToArray();

var lines = harness.GetPuzzleComparison(puzzles);

Console.WriteLine();
Console.WriteLine("17-hint puzzles..");
Console.WriteLine();
Console.WriteLine(string.Join(Environment.NewLine, lines));

lines = harness.GetSparseComparison(1, 5, puzzles);

Console.WriteLine();
Console.WriteLine("Sparse puzzles with 1-5 hints...");
Console.WriteLine();
Console.WriteLine(string.Join(Environment.NewLine, lines));