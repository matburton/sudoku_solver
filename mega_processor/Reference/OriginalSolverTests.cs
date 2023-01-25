
using NUnit.Framework;

namespace Megaprocessor.Reference.SudokuSolver;

internal sealed class OriginalSolverTests
{
    [TestCase("96.3.......7.2.4..1....8...3..1...6..8......5..9.7.2.....6....9.....5.8.....4.7..",
              "964317852837529416125468397372154968486293175519876243743681529291735684658942731")]
    public void Can_solve_puzzle(string puzzleLine, string solutionLine)
    {
        var solver = new OriginalSolver();

        var grid = Parser.FromLine(puzzleLine);

        solver.OnGridChange += g =>
        {
            Assert.That(g.Line, Is.Not.EqualTo(grid.Line));

            grid = g;
        };

        solver.Solve(grid);

        Assert.That(grid.Line, Is.EqualTo(solutionLine));

        Assert.That(solver.Counters.Solutions, Is.EqualTo(1));
    }
}