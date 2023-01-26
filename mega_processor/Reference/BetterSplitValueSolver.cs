
namespace Megaprocessor.Reference.SudokuSolver;

internal sealed class BetterSplitValueSolver : OriginalSolver
{
    protected override void SpitGridAt(G grid, int x, int y)
    {
        // We first check if the stack is getting close to the code/data

        var possibility = GetBestPossibilityAt(grid, x, y);

        var cloneGrid = new G();

        grid.CopyTo(cloneGrid);

        ++_disableRender;

        RemovePossibilityAt(grid, possibility, x, y);

        --_disableRender;

        if (grid.Impossible)
        {
            cloneGrid.CopyTo(grid);

            SetValueAt(grid, possibility, x, y);

            return;
        }

        ++_counters.GridsInMemory;

        SetValueAt(cloneGrid, possibility, x, y);

        Solve(cloneGrid);

        --_counters.GridsInMemory;

        Render(grid);
    }

    private int GetBestPossibilityAt(G grid, int x, int y)
    {
        var possibilities = grid.Squares[x, y].Possibilities;

        ++_counters.SquareHits;

        var bestValue = 0;

        var bestScore = -1;

        var value = 9;

        for (; value > 0; --value)
        {
            var mask = 1 << value; // bset

            if ((possibilities & mask) is 0) continue;

            var score = ScoreValue(grid, x, y, mask);

            if (score <= bestScore) continue;

            bestScore = score;

            bestValue = value;
        }

        return bestValue;
    }

    private int ScoreValue(G grid, int x, int y, int mask)
    {
        var score = 0;

        void IncrementIfPossible(int x, int y)
        {
            ++_counters.SquareHits;

            if ((grid.Squares[x, y].Possibilities & mask) is 0) return;

            ++score;
        }

        for (var index = 0; index < 9; ++index) IncrementIfPossible(index, y);

        for (var index = 0; index < 9; ++index) IncrementIfPossible(x, index);

        var otherXA = SectorOtherCoordLookupFromCoord[x + x];
        var otherXB = SectorOtherCoordLookupFromCoord[x + x + 1]; // Pointer bump
        var otherYA = SectorOtherCoordLookupFromCoord[y + y];
        var otherYB = SectorOtherCoordLookupFromCoord[y + y + 1]; // Pointer bump

        IncrementIfPossible(otherXB, otherYB);
        IncrementIfPossible(otherXB, otherYA);
        IncrementIfPossible(otherXA, otherYA);
        IncrementIfPossible(otherXA, otherYB);

        return score;
    }
}