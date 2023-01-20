
namespace Megaprocessor.Reference.SudokuSolver;

internal static class Parser
{
    public static Grid FromLine(string line) =>
        new (line.Select(c => c is '.' or '0' ? (int?)null : int.Parse($"{c}"))
                 .Chunk(9)
                 .ToArray());
}