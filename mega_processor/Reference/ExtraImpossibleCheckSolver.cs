
namespace Megaprocessor.Reference.SudokuSolver;

internal sealed class ExtraImpossibleCheckSolver : OriginalSolver
{
    protected override void RefineGrid(G grid)
    {
        base.RefineGrid(grid);

        for (var value = 9; value > 0; --value)
        {
            var mask = 1 << value;

            for (var index = 8; index >= 0; --index)
            {
                if (   !RowHasPossibility   (grid, mask, index)
                    || !ColumnHasPossibility(grid, mask, index)
                    || !SectorHasPossibility(grid, mask, index))
                {
                    grid.Impossible = true;

                    return;
                }
            }
        }
    }

    private bool RowHasPossibility(G grid, int mask, int index)
    {
        for (var x = 8; x >= 0; --x)
        {
            ++_counters.SquareHits;

            if ((grid.Squares[x, index].Possibilities & mask) is not 0)
            {
                return true;
            }
        }

        return false;
    }

    private bool ColumnHasPossibility(G grid, int mask, int index)
    {
        for (var y = 8; y >= 0; --y)
        {
            ++_counters.SquareHits;

            if ((grid.Squares[index, y].Possibilities & mask) is not 0)
            {
                return true;
            }
        }

        return false;
    }

    private bool SectorHasPossibility(G grid, int mask, int index)
    {
        var startX = (index % 3) * 3;
        var startY = (index / 3) * 3;

        for (var y = startY; y < startY + 3; ++y)
        for (var x = startX; x < startX + 3; ++x)
        {
            ++_counters.SquareHits;

            if ((grid.Squares[x, y].Possibilities & mask) is not 0)
            {
                return true;
            }
        }

        return false;
    }
}