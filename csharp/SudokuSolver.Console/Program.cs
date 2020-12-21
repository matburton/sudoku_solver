
using System;
using System.Collections.Generic;

using SudokuSolver.Core;

var grids = new List<Grid> { new (5) };

Console.WriteLine("Searching for {0} x {0} solutions...", grids[0].Dimension);

while (grids.Count > 0 && !grids[0].IsComplete)
{
    Solver.AdvanceSolving(grids);
}

if (grids.Count > 1) Console.WriteLine($"\r\nSolution {grids[0]}");

Console.WriteLine("\r\nDone");