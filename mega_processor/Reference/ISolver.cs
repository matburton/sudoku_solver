
namespace Megaprocessor.Reference.SudokuSolver;

internal interface ISolver
{
    public Grid Solve(Grid puzzle);

    public Counters Counters { get; }

    public event Action<Grid> OnGridChange;
}