
using NUnit.Framework;

namespace Megaprocessor.Reference.SudokuSolver;

internal sealed class OriginalSolverTests
{
    [TestCase("96.3.......7.2.4..1....8...3..1...6..8......5..9.7.2.....6....9.....5.8.....4.7..",
              "964317852837529416125468397372154968486293175519876243743681529291735684658942731")]
    [TestCase(".......1.4.........2...........5.4.7..8...3....1.9....3..4..2...5.1........8.6...",
              "693784512487512936125963874932651487568247391741398625319475268856129743274836159")]
    [TestCase("5..3...........42....7.....6...1..53.7..48............2..5......4....8..........9",
              "528364197739851426416792538684217953375948612192635784267589341943126875851473269")]
    public void Can_solve_puzzle(string puzzleLine, string solutionLine)
    {
        var solver = new OriginalSolver();

        var grid = Parser.FromLine(puzzleLine);

        var maxInMemory = 0;

        solver.OnGridChange += g =>
        {
            grid = g;

            maxInMemory = Math.Max(maxInMemory, solver.Counters.GridsInMemory);
        };

        solver.Solve(grid);

        Assert.That(grid.Line, Is.EqualTo(solutionLine));

        Assert.That(solver.Counters.Solutions, Is.EqualTo(1));

        Assert.That(solver.Counters.ImpossibleGrids,
                    Is.LessThanOrEqualTo(192));

        Assert.That(solver.Counters.SquareHits,
                    Is.LessThanOrEqualTo(112_459));

        Assert.That(maxInMemory, Is.LessThanOrEqualTo(8));
    }

    [Test]
    public void Can_solve_puzzle_of_doom()
    {
        var solver = new OriginalSolver();

        var grid = Parser.FromLine(  ".9...37......5...4..12...6..45.6.....3..."
                                   + "4...2..7..........93....6....1.7...8...2");

        solver.OnGridChange += g => grid = g;

        solver.Solve(grid);

        Assert.That(grid.Line,
                    Is.EqualTo("69284375187315692445129786314596823793752"
                               + "4186268731495524619378386472519719385642"));

        Assert.That(solver.Counters.Solutions, Is.EqualTo(1));

        Assert.That(solver.Counters.ImpossibleGrids,
                    Is.LessThanOrEqualTo(236));

        Assert.That(solver.Counters.SquareHits,
                    Is.LessThanOrEqualTo(112_884));
    }

    [Test]
    public void Can_solve_blank_grid()
    {
        var solver = new OriginalSolver();

        var grid = Parser.FromLine(new ('.', 81));

        var maxInMemory = 0;

        solver.OnGridChange += g =>
        {
            grid = g;

            maxInMemory = Math.Max(maxInMemory, solver.Counters.GridsInMemory);
        };

        solver.Solve(grid);

        Assert.That(grid.Line,
                    Is.EqualTo("835967241974312865261548397398275614647891"
                               + "532512634978456789123789123456123456789"));

        Assert.That(solver.Counters.Solutions, Is.EqualTo(2));

        Assert.That(solver.Counters.ImpossibleGrids, Is.EqualTo(0));

        Assert.That(solver.Counters.SquareHits, Is.LessThanOrEqualTo(65_948));

        Assert.That(maxInMemory, Is.LessThanOrEqualTo(48));
    }
}