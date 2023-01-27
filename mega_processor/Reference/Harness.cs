
namespace Megaprocessor.Reference.SudokuSolver;

internal sealed record Harness(Func<ISolver> BaseSolver,
                               Func<ISolver> NewSolver)
{
    public IEnumerable<string> GetPuzzleComparison(params Grid[] puzzles)
    {
        var counters = puzzles
            .AsParallel()
            .Select(p => new PuzzleCounters(p,
                                            Solve(BaseSolver(), p),
                                            Solve(NewSolver(),  p)))
            .OrderBy(c => c.BaseSolver.AtComplete.SquareHits)
            .ToArray();

        if (counters.Where(c => c.BaseSolver.AtComplete.Solutions
                             != c.NewSolver.AtComplete.Solutions)
                    .Take(1)
                    .ToArray() is [var c])
        {
            throw new Exception("Solvers found different number of"
                                + $" solutions for puzzle: {c.Puzzle.Line}");
        }

        if (counters.Where(c => c.BaseSolver.AtComplete.Solutions is 1)
                    .Any(c => c.BaseSolver.Solution.Line
                           != c.NewSolver.Solution?.Line))
        {
            throw new Exception("Solvers found different solution for a puzzle");
        }

        var chunkDeltas = counters.Chunk(counters.Length / 10 + 1)
                                  .Select(ToDeltas)
                                  .ToArray();

        double ToRatio(int index) =>
              chunkDeltas.Take(index).Sum(c => (double)c.SampleCount)
            / chunkDeltas.Sum(c => (double)c.SampleCount);

        yield return $"Comparison using {puzzles.Length:#,#} grids:"
                   + " (easiest @ 0%, hardest @ 100%, negative better)";

        for (var index = 0; index < chunkDeltas.Length; ++index)
        {
            var d = chunkDeltas[index];

            yield return $"* {ToRatio(index),3:0%} - {ToRatio(index + 1),4:0%}:"
                       + $" hits@solve: {FormatPercent(d.AtSolve.SquareHitsRatio)}"
                       + $" hits@end: {FormatPercent(d.AtComplete.SquareHitsRatio)}"
                       + $" imposs@solve: {FormatPercent(d.AtSolve.ImpossibleGridsRatio)}"
                       + $" imposs@end: {FormatPercent(d.AtComplete.ImpossibleGridsRatio)}"
                       + $" maxInMem: {FormatPercent(d.MaxGridsInMemoryRatio)}";
        }
    }

    private static string FormatPercent(double v)
    {
        if (v is < 0.001 and > -0.001 or double.NaN) return new string(' ', 7);

        return v > 0 ? $"\u001b[1;31m{v,-7:+0.#%;-0.#%}\u001b[0m"
                     : $"\u001b[1;32m{v,-7:+0.#%;-0.#%}\u001b[0m";
    }

    public IEnumerable<string> GetSparseComparison(int minValues,
                                                   int maxValues,
                                                   params Grid[] puzzles)
    {
        var random = new Random(1337);

        Grid RemoveHints(Grid grid)
        {
            var hintCoords = grid.Values
                .SelectMany((r, y) => r.Select((v, x) => (x, y, v)))
                .Where(t => t.v is {})
                .ToList();

            var wantedHintCount = random.Next(minValues, maxValues + 1);

            while (hintCoords.Count > wantedHintCount)
            {
                hintCoords.RemoveAt(random.Next(0, hintCoords.Count));
            }

            var coordValues = hintCoords.ToDictionary(t => (t.x, t.y), t => t.v);

            int? GetAt(int x, int y) =>
                coordValues.TryGetValue((x, y), out var v) ? v : null;

            return new
                (Enumerable.Range(0, 9)
                           .Select(y => Enumerable.Range(0, 9)
                                                  .Select(x => GetAt(x, y))
                                                  .ToArray())
                           .ToArray());
        }

        return GetPuzzleComparison(puzzles.Select(RemoveHints).ToArray());
    }

    private static Deltas ToDeltas(PuzzleCounters[] counters)
    {
        var solved = counters.Where(c => c.BaseSolver.Solution is {}).ToArray();

        double GetRatio(PuzzleCounters[] a, Func<SolverCounters, int> v) =>
              a.Sum(c => (double)v(c.NewSolver))
            / a.Sum(c => (double)v(c.BaseSolver))
            - 1;

        var atSolve = new Delta
            (GetRatio(solved, c => c.AtSolve.SquareHits),
             GetRatio(solved, c => c.AtSolve.ImpossibleGrids));

        var atComplete = new Delta
            (GetRatio(counters, c => c.AtComplete.SquareHits),
             GetRatio(counters, c => c.AtComplete.ImpossibleGrids));

        var maxGridsInMemory = GetRatio(counters, c => c.MaxGridsInMemory);

        return new (counters.Length, atSolve, atComplete, maxGridsInMemory);
    }

    private static SolverCounters Solve(ISolver solver, Grid grid)
    {
        var maxGridsInMemory = 0;

        Counters atSolve = null;

        Grid solution = null;

        void OnGridChange(Grid g)
        {
            maxGridsInMemory = Math.Max(maxGridsInMemory,
                                        solver.Counters.GridsInMemory);

            if (solution is not null || solver.Counters.Solutions is 0) return;

            solution = g;

            atSolve = solver.Counters;
        }

        solver.OnGridChange += OnGridChange;

        try
        {
            solver.Solve(grid);
        }
        catch (Exception exception)
        {
            throw new Exception($"Solver {solver} failed on {grid.Line}:"
                                + $"\r\n\r\n{grid.ToAsciiArt()}\r\n\r\n",
                                exception);
        }

        solver.OnGridChange -= OnGridChange;

        return new (solution, atSolve, solver.Counters, maxGridsInMemory);
    }

    private sealed record PuzzleCounters(Grid Puzzle,
                                         SolverCounters BaseSolver,
                                         SolverCounters NewSolver);

    private sealed record SolverCounters(Grid Solution,
                                         Counters AtSolve,
                                         Counters AtComplete,
                                         int MaxGridsInMemory);

    private sealed record Delta(double SquareHitsRatio,
                                double ImpossibleGridsRatio);

    private sealed record Deltas(int SampleCount,
                                 Delta AtSolve,
                                 Delta AtComplete,
                                 double MaxGridsInMemoryRatio);
}