
using NUnit.Framework;

namespace Megaprocessor.Reference.SudokuSolver;

internal sealed class ParserTests
{
    [TestCase("96.3.......7.2.4..1....8...3..1...6..8......5..9.7.2.....6....9.....5.8.....4.7..")]
    [TestCase("960300000007020400100008000300100060080000005009070200000600009000005080000040700")]
    public void Can_parse_puzzle(string line)
    {
        var grid = Parser.FromLine(line);

        Assert.That(grid.Values, Is.EqualTo(new []
        {
            new int?[] { 9,    6,    null,  3,    null, null,  null, null, null },
            new int?[] { null, null, 7,     null, 2,    null,  4,    null, null },
            new int?[] { 1,    null, null,  null, null, 8,     null, null, null },
                                                               
            new int?[] { 3,    null, null,  1,    null, null,  null, 6,    null },
            new int?[] { null, 8,    null,  null, null, null,  null, null, 5    },
            new int?[] { null, null, 9,     null, 7,    null,  2,    null, null },
                                                               
            new int?[] { null, null, null,  6,    null, null,  null, null, 9    },
            new int?[] { null, null, null,  null, null, 5,     null, 8,    null },
            new int?[] { null, null, null,  null, 4,    null,  7,    null, null },
        }));
    }
}