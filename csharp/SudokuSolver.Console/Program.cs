
using System;
using SudokuSolver.Core;

var grid = new Grid(4);

grid.SetSquareValue((1, 2), 3);

Console.WriteLine(grid);

Console.WriteLine("Done");