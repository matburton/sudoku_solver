
using System;
using System.Collections.Generic;
using System.Diagnostics;

using SudokuSolver.Core;

var grids = new List<Grid> { new (6) };

Console.WriteLine("\r\nSearching for {0} x {0} solutions...", grids[0].Dimension);

var counters = new Counters();

var stopWatch = new Stopwatch();

stopWatch.Start();

var lastReportedCounters = true;

while (counters.Solutions is 0)
{
    Solver.AdvanceSolving(grids, counters);
    
    if (grids.Count is 0) break;
    
    if (grids[0].IsComplete)
    {
        ++counters.Solutions;
        
        Console.WriteLine($"\r\nSolution: {grids[0]}");
        
        Console.WriteLine(counters.ToString(grids));
    }
    else if (stopWatch.ElapsedMilliseconds >= 15000)
    {
        Console.WriteLine(lastReportedCounters ? $"\r\nCurrent grid: {grids[0]}"
                                               : counters.ToString(grids));
        stopWatch.Restart();
        
        lastReportedCounters = !lastReportedCounters;
    }
}

Console.WriteLine();