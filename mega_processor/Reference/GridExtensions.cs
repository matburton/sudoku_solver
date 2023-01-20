
namespace Megaprocessor.Reference.SudokuSolver;

internal static class GridExtensions
{
    public static string ToAsciiArt(this Grid grid)
    {
        var lines = grid.Values.Select
            (r => string.Join(" | ", r.Select(v => v is null ? "." : $"{v}")
                                      .Chunk(3)
                                      .Select(s => string.Join(' ', s))));

        return string.Join($"\r\n{new string('-', 21)}\r\n",
                           lines.Chunk(3).Select(s => string.Join("\r\n", s)));
    }
}