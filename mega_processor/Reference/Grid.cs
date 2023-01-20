
using System.Diagnostics;

namespace Megaprocessor.Reference.SudokuSolver;

[DebuggerDisplay("{Line}")]
internal sealed class Grid
{
    public Grid(params int?[][] values)
    {
        if (   values.Length is not 9
            || values.Any(r => r.Length is not 9)
            || values.SelectMany(v => v)
                     .Where(v => v is not null)
                     .Any(v => v is < 1 or > 9))
        {
            throw new ArgumentException("Invalid grid values", nameof(values));
        }

        Values = values.Select(v => v.ToArray()).ToArray();
    }

    public string Line => string.Concat
        (Values.SelectMany(r => r).Select(v => v is null ? "." : $"{v}"));

    public IReadOnlyList<IReadOnlyList<int?>> Values { get; }
}