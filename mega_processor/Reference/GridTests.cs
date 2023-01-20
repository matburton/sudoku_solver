
using NUnit.Framework;

namespace Megaprocessor.Reference.SudokuSolver;

internal class GridTests
{
    [Test]
    public void Can_round_trip_line()
    {
        const string line =
            "96.3.......7.2.4..1....8...3..1...6..8......5..9.7.2.....6....9.....5.8.....4.7..";

        Assert.That(Parser.FromLine(line).Line, Is.EqualTo(line));
    }
}