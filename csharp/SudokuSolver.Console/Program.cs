
using System;
using System.Diagnostics;

using SudokuSolver.Core;

var grids = new GridCollection(new Grid(6));

Console.WriteLine("\r\nSearching for {0} x {0} solutions...",
                  grids.Now.Dimension);

var counters = new Counters();

var stopWatch = new Stopwatch();

stopWatch.Start();

var lastReportedCounters = true;

while (counters.Solutions is 0)
{
    Solver.AdvanceSolving(grids, counters);
    
    if (grids.Count is 0) break;
    
    if (grids.Now.IsComplete)
    {
        ++counters.Solutions;
        
        Console.WriteLine($"\r\nSolution: {grids.Now}");
        
        Console.WriteLine(counters.ToString(grids));
    }
    else if (stopWatch.ElapsedMilliseconds >= 15000)
    {
        Console.WriteLine(lastReportedCounters ? $"\r\nCurrent grid: {grids.Now}"
                                               : counters.ToString(grids));
        stopWatch.Restart();
        
        lastReportedCounters = !lastReportedCounters;
    }
}

Console.WriteLine();