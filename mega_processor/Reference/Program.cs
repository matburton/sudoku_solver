
using Megaprocessor.Reference.SudokuSolver;

var harness = new Harness(() => new OriginalSolver(),
                          () => new OriginalSolver());

var puzzles = File
    .ReadAllLines(@"../../../../../puzzles/sudoku17/puzzles.txt")
    .Take(10_000)
    .Select(Parser.FromLine)
    .ToArray();

var lines = harness.GetPuzzleComparison(puzzles);

Console.WriteLine();
Console.WriteLine("17-hint puzzles..");
Console.WriteLine();
Console.WriteLine(string.Join(Environment.NewLine, lines));

lines = harness.GetSparseComparison();

Console.WriteLine();
Console.WriteLine("Sparse grids...");
Console.WriteLine();
Console.WriteLine(string.Join(Environment.NewLine, lines));