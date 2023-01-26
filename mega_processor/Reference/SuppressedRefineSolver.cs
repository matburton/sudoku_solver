
namespace Megaprocessor.Reference.SudokuSolver;

internal sealed class SuppressedRefineSolver : OriginalSolver
{
    public required int EnableUponCompleteSquareCount { private get; init; }

    protected override void RefineGrid(G grid)
    {
        var completeSquareCount = 81 - grid.IncompleteSquares;

        if (completeSquareCount < EnableUponCompleteSquareCount) return;
        
        base.RefineGrid(grid);
    }
}