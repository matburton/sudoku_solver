
namespace Megaprocessor.Reference.SudokuSolver;

internal sealed record Counters
{
    public int SquareHits { get; set; }

    public int Solutions { get; set; }

    public int ImpossibleGrids { get; set; }

    public int GridsInMemory { get; set; }
}