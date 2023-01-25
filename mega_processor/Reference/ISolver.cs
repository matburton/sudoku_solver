
namespace Megaprocessor.Reference.SudokuSolver;

internal interface ISolver
{
    /// <remarks>Subscribe to OnGridChange to get the final
    ///          output, which should normally either be the
    ///          first solution found or an impossible grid</remarks>
    ///
    public void Solve(Grid puzzle);

    public Counters Counters { get; }

    public event Action<Grid> OnGridChange;
}