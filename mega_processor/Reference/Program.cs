
using Megaprocessor.Reference.SudokuSolver;

Console.WriteLine("Paste puzzle line:");

var grid = Parser.FromLine(Console.ReadLine());

var solver = new OriginalSolver();

solver.OnGridChange += g => grid = g;

solver.Solve(grid);

Console.WriteLine(grid.Line);

Console.WriteLine();
Console.WriteLine($"Solutions:        {solver.Counters.Solutions}");
Console.WriteLine($"Impossible grids: {solver.Counters.ImpossibleGrids}");
Console.WriteLine($"Square 'hits':    {solver.Counters.SquareHits}");
Console.WriteLine();
Console.WriteLine(grid.ToAsciiArt());