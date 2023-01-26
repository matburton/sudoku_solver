
namespace Megaprocessor.Reference.SudokuSolver;

internal sealed record Harness(Func<ISolver> BaseSolver,
                               Func<ISolver> NewSolver)
{
    public IEnumerable<string> GetPuzzleComparison(params Grid[] puzzles)
    {
        var counters = puzzles
            .AsParallel()
            .Select(p => new PuzzleCounters(Solve(BaseSolver(), p),
                                            Solve(NewSolver(),  p)))
            .OrderBy(c => c.BaseSolver.AtComplete.SquareHits)
            .ToArray();

        if (counters.Any(c => c.BaseSolver.AtComplete.Solutions
                           != c.NewSolver.AtComplete.Solutions))
        {
            throw new Exception("Solvers found different number of"
                                + " of solutions for a puzzle");
        }

        if (counters.Where(c => c.BaseSolver.Solution is not null)
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

        yield return "Comparison: (easiest @ 0%, hardest @ 100%, negatives better)";

        for (var index = 0; index < chunkDeltas.Length; ++index)
        {
            var d = chunkDeltas[index];

            yield return $"* {ToRatio(index),3:0%} - {ToRatio(index + 1),4:0%}:"
                       + $" hits@solve: {d.AtSolve.SquareHits,-6:+0;-0}"
                       + $" hits@end: {d.AtComplete.SquareHits,-6:+0;-0}"
                       + $" imposs@solve: {d.AtSolve.ImpossibleGrids,-6:+0;-0}"
                       + $" imposs@end: {d.AtComplete.ImpossibleGrids,-6:+0;-0}"
                       + $" maxInMem: {d.MaxGridsInMemory,-6:+0;-0}";
        }
    }

    public IEnumerable<string> GetSparseComparison(int maxValues = 5,
                                                   int samples   = 10_000,
                                                   int seed      = 1337)
    {
        var random = new Random(seed);

        Grid CreateGrid()
        {
            var values = new int?[9, 9];

            for (var index = 0; index < random.Next(1, maxValues + 1); ++index)
            {
                values[random.Next(0, 9), random.Next(0, 9)] = random.Next(1, 10);
            }

            int?[] FromRow(int y) =>
                Enumerable.Range(0, 9).Select(x => values[x, y]).ToArray();

            return new (Enumerable.Range(0, 9).Select(FromRow).ToArray());
        }

        return GetPuzzleComparison
            (Enumerable.Range(0, samples).Select(_ => CreateGrid()).ToArray());
    }

    private static Deltas ToDeltas(IEnumerable<PuzzleCounters> counters)
    {
        counters = counters.ToArray();

        var solved = counters.Where(c => c.BaseSolver.Solution is {})
                                     .ToArray();
        var atSolve = new Delta
            (  solved.Sum(c => c.NewSolver.AtSolve.SquareHits)
             - solved.Sum(c => c.BaseSolver.AtSolve.SquareHits),
               solved.Sum(c => c.NewSolver.AtSolve.ImpossibleGrids)
             - solved.Sum(c => c.BaseSolver.AtSolve.ImpossibleGrids));

        var atComplete = new Delta
            (  solved.Sum(c => c.NewSolver.AtComplete.SquareHits)
             - solved.Sum(c => c.BaseSolver.AtComplete.SquareHits),
               solved.Sum(c => c.NewSolver.AtComplete.ImpossibleGrids)
             - solved.Sum(c => c.BaseSolver.AtComplete.ImpossibleGrids));

        var maxGridsInMemory = counters.Sum(c => c.NewSolver.MaxGridsInMemory)
                             - counters.Sum(c => c.BaseSolver.MaxGridsInMemory);

        return new (counters.Count(), atSolve, atComplete, maxGridsInMemory);
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

        solver.Solve(grid);

        solver.OnGridChange -= OnGridChange;

        return new (solution, atSolve, solver.Counters, maxGridsInMemory);
    }

    private sealed record PuzzleCounters(SolverCounters BaseSolver,
                                         SolverCounters NewSolver);

    private sealed record SolverCounters(Grid Solution,
                                         Counters AtSolve,
                                         Counters AtComplete,
                                         int MaxGridsInMemory);

    private sealed record Delta(int SquareHits, int ImpossibleGrids);

    private sealed record Deltas(int SampleCount,
                                 Delta AtSolve,
                                 Delta AtComplete,
                                 int MaxGridsInMemory);
}