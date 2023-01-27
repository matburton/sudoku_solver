
namespace Megaprocessor.Reference.SudokuSolver;

using static BitInstructions;

/// <remarks>This doesn't have a new cache or new rules yet</remarks>
///
internal class ValueCountCacheSolver : ISolver
{
    public void Solve(Grid puzzle)
    {
        ++_disableRender;

        var grid = new G();

        try
        {
            for (var y = 8; y >= 0; --y)
            for (var x = 8; x >= 0; --x)
            {
                if (puzzle.Values[y][x] is {} value)
                {
                    SetHintAt(grid, value, x, y);
                }
            }
        }
        catch (ImpossibleException) {}

        --_disableRender;

        SpitGrid(grid);
    }

    private void SpitGrid(G grid)
    {
        do
        {
            if (grid.Impossible)
            {
                ++_counters.ImpossibleGrids;

                return;
            }

            if (grid.IncompleteSquares is 0)
            {
                ++_counters.Solutions;

                Render(grid); // Not needed in the real thing

                ++_disableRender;

                return;
            }

            GetSplitSpot(grid, out var x, out var y);

            SpitGridAt(grid, x, y);
        }
        while (_counters.Solutions < 2);
    }

    protected virtual void SpitGridAt(G grid, int x, int y)
    {
        // We first check if the stack is getting close to the code/data

        var possibility = GetAPossibilityAt(grid, x, y);

        var cloneGrid = new G();

        grid.CopyTo(cloneGrid);

        ++_disableRender;

        try
        {
            RemovePossibilityAt(grid, possibility, x, y);
        }
        catch (ImpossibleException)
        {
            --_disableRender;

            ++_counters.ImpossibleGrids;

            cloneGrid.CopyTo(grid);

            try
            {
                SetValueAt(grid, possibility, x, y);
            }
            catch (ImpossibleException) {}

            return;
        }

        --_disableRender;

        if (grid.IncompleteSquares is 0)
        {
            if (_counters.Solutions is not 0) return;

            ++_counters.Solutions;

            Render(grid);

            ++_disableRender;

            cloneGrid.CopyTo(grid);

            try
            {
                SetValueAt(grid, possibility, x, y);
            }
            catch (ImpossibleException) {}

            return;
        }

        ++_counters.GridsInMemory;

        try
        {
            SetValueAt(cloneGrid, possibility, x, y);
        }
        catch (ImpossibleException) {}

        SpitGrid(cloneGrid); // Has to be counted!

        --_counters.GridsInMemory;

        Render(grid);
    }

    private void GetSplitSpot(G grid, out int x, out int y)
    {
        var bestPossibilityCount = 10;

        (x, y) = (0, 0); // In reality these wouldn't be initialized

        for (var indexY = 8; indexY >= 0; --indexY)
        for (var indexX = 8; indexX >= 0; --indexX)
        {
            ++_counters.SquareHits;

            var possibilityCount = grid.Squares[indexX, indexY].PossibilityCount;

            if (possibilityCount - bestPossibilityCount >= 0) continue;

            if (possibilityCount < 2) continue;

            x = indexX;
            y = indexY;

            if (possibilityCount is 2) return;

            bestPossibilityCount = possibilityCount;
        }
    }
    
    private void SetHintAt(G grid, int value, int x, int y)
    {
        var possibilities = grid.Squares[x, y].Possibilities;

        ++_counters.SquareHits;

        if (!BitClear(ref possibilities, value))
        {
            grid.Squares[x, y].Value = value;

            grid.Impossible = true;

            throw new ImpossibleException();
        }
        else if (possibilities is not 0)
        {
            SetValueAt(grid, value, x, y);
        }
    }

    // Assumes the square has the value and had others
    //
    protected void SetValueAt(G grid, int value, int x, int y)
    {
        SetSquareValue(grid, value, x, y);

        Render(grid);

        RemovePossibilitiesRelatedTo(grid, value, x, y);
    }

    protected void RemovePossibilityAt(G grid, int value, int x, int y)
    {
        ++_counters.SquareHits;

        var square = grid.Squares[x, y];

        var possibilities = square.Possibilities;

        if (!BitClear(ref possibilities, value)) return;

        square.Possibilities = possibilities;

        if (square.PossibilityCount is 1)
        {
            grid.Impossible = true;

            throw new ImpossibleException();
        }

        --square.PossibilityCount;

        if (square.PossibilityCount is not 1) return;

        --grid.IncompleteSquares;

        square.Value = CalculateValue(square.Possibilities);

        Render(grid);

        RemovePossibilitiesRelatedTo(grid, square.Value, x, y);
    }

    private void RemovePossibilitiesRelatedTo(G grid, int value, int x, int y)
    {
        RemovePossibilitiesRelatedToRow   (grid, value, x, y);
        RemovePossibilitiesRelatedToColumn(grid, value, x, y);
        RemovePossibilitiesRelatedToSector(grid, value, x, y);
    }

    private void RemovePossibilitiesRelatedToRow(G grid, int value, int x, int y)
    {
        for (var index = x - 1; index >= 0; --index)
        {
            RemovePossibilityAt(grid, value, index, y);
        }

        for (var index = 8; index > x; --index)
        {
            RemovePossibilityAt(grid, value, index, y);
        }
    }

    private void RemovePossibilitiesRelatedToColumn(G grid, int value, int x, int y)
    {
        for (var index = y - 1; index >= 0; --index)
        {
            RemovePossibilityAt(grid, value, x, index);
        }

        for (var index = 8; index > y; --index)
        {
            RemovePossibilityAt(grid, value, x, index);
        }
    }

    protected static readonly IReadOnlyList<int> SectorOtherCoordLookupFromCoord =
        new [] { 1, 2, 0, 2, 0, 1, 4, 5, 3, 5, 3, 4, 7, 8, 6, 8, 6, 7 };

    private void RemovePossibilitiesRelatedToSector(G grid, int value, int x, int y)
    {
        var otherXA = SectorOtherCoordLookupFromCoord[x + x];
        var otherXB = SectorOtherCoordLookupFromCoord[x + x + 1]; // Pointer bump
        var otherYA = SectorOtherCoordLookupFromCoord[y + y];
        var otherYB = SectorOtherCoordLookupFromCoord[y + y + 1]; // Pointer bump

        RemovePossibilityAt(grid, value, otherXB, otherYB);
        RemovePossibilityAt(grid, value, otherXB, otherYA);
        RemovePossibilityAt(grid, value, otherXA, otherYA);
        RemovePossibilityAt(grid, value, otherXA, otherYB);
    }

    // Assumes the square has the value and had others
    //
    private void SetSquareValue(G grid, int value, int x, int y)
    {
        --grid.IncompleteSquares;

        var square = grid.Squares[x, y];

        ++_counters.SquareHits;

        square.Possibilities = 1 << value; // Uses bset

        square.PossibilityCount = 1;

        square.Value = value;
    }

    private int GetAPossibilityAt(G grid, int x, int y)
    {
        var possibilities = grid.Squares[x, y].Possibilities;

        ++_counters.SquareHits;

        var value = 9;

        for (; value > 0; --value)
        {
            if (BitTest(possibilities, value))
            {
                break;
            }
        }

        return value;
    }

    // Assumes there is a single bit set
    //
    private static int CalculateValue(int possibilities)
    {
        var mask = 2;

        var value = 1;

        while (possibilities != mask)
        {
            mask += mask;

            ++value;
        }

        return value;
    }

    protected void Render(G grid)
    {
        if (_disableRender is 0) OnGridChange(new (grid.ToValues()));
    }

    public Counters Counters => _counters with {};

    public event Action<Grid> OnGridChange =  delegate {};

    protected sealed class G
    {
        public G()
        {
            for (var y = 0; y < 9; ++y) // In reality this just overwrites the
            for (var x = 0; x < 9; ++x) // block of memory with constant words
            {
                Squares[x, y] = new () { Possibilities    = 0b11_11111110,
                                         PossibilityCount = 9,
                                         Value            = 0 };
            }
        }

        public Square[,] Squares { get; } = new Square[9, 9];

        public int IncompleteSquares { get; set; } = 81;

        public bool Impossible { get; set; }

        public void CopyTo(G target)
        {
            for (var y = 0; y < 9; ++y) // In reality this just copies the
            for (var x = 0; x < 9; ++x) // entire block of memory as words
            {
                target.Squares[x, y] = Squares[x, y] with {};
            }

            target.IncompleteSquares = IncompleteSquares;

            target.Impossible = Impossible;
        }

        public int?[][] ToValues()
        {
            int?[] FromRow(int y) => Enumerable
                                    .Range(0, 9)
                                    .Select(x => Squares[x, y].Value)
                                    .Select(v => v is 0 ? (int?)null : v)
                                    .ToArray();

            return Enumerable.Range(0, 9).Select(FromRow).ToArray();
        }
    }

    protected sealed record Square
    {
        public int Possibilities { get; set; }

        public int Value { get; set; }

        public int PossibilityCount { get; set; }
    }

    public sealed class ImpossibleException : Exception {}

    protected readonly Counters _counters = new () { GridsInMemory = 1 };

    protected int _disableRender;
}