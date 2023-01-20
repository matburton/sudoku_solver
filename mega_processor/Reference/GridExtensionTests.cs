
using NUnit.Framework;

namespace Megaprocessor.Reference.SudokuSolver;

internal class GridExtensionTests
{
    [Test]
    public void ToAsciiArt_is_correct()
    {
        var grid = Parser.FromLine
            ("96.3.......7.2.4..1....8...3..1...6..8......5..9.7.2.....6....9.....5.8.....4.7..");

        Assert.That(grid.ToAsciiArt(), Is.EqualTo("""
                                                  9 6 . | 3 . . | . . .
                                                  . . 7 | . 2 . | 4 . .
                                                  1 . . | . . 8 | . . .
                                                  ---------------------
                                                  3 . . | 1 . . | . 6 .
                                                  . 8 . | . . . | . . 5
                                                  . . 9 | . 7 . | 2 . .
                                                  ---------------------
                                                  . . . | 6 . . | . . 9
                                                  . . . | . . 5 | . 8 .
                                                  . . . | . 4 . | 7 . .
                                                  """));
    }
}