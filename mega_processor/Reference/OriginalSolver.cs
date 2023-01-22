
namespace Megaprocessor.Reference.SudokuSolver;

using static BitInstructions;

internal sealed class OriginalSolver : ISolver
{
    public Grid Solve(Grid puzzle)
    {
        _disableRender = true;

        var grid = new G();

        for (var y = 8; y > 0; --y)
        for (var x = 8; x > 0; --x)
        {
            if (puzzle.Values[y][x] is {} value)
            {
                SetHintAt(grid, value, x, y);
            }
        }

        _disableRender = false;

        // TODO

        return new (grid.ToValues());
    }
    
    private void SetHintAt(G grid, int value, int x, int y)
    {
        var possibilities = grid.Squares[x, y].Possibilities;

        ++Counters.SquareHits;

        if (!BitClear(ref possibilities, value))
        {
            grid.Squares[x, y].Value = value;

            grid.Impossible = true;
        }
        else if (possibilities is not 0)
        {
            SetValueAt(grid, value, x, y);
        }
    }

    // Assumes the square has the value and had others
    //
    private void SetValueAt(G grid, int value, int x, int y)
    {
        SetSquareValue(grid, value, x, y);

        Render(grid);

        RemovePossibilitiesRelatedTo(grid, value, x, y);
    }

    private void RemovePossibilityAt(G grid, int value, int x, int y)
    {
        ++Counters.SquareHits;

        var square = grid.Squares[x, y];

        var possibilities = square.Possibilities;

        if (!BitClear(ref possibilities, value)) return;

        square.Possibilities = possibilities;

        if (square.PossibilityCount is 1)
        {
            grid.Impossible = true;

            if (_earlyOutThrow) throw new EarlyOutException();

            return;
        }

        --square.PossibilityCount;

        if (square.PossibilityCount is not 1) return;

        --grid.IncompleteSquares;

        square.Value = CalculateValue(square.Possibilities);

        RefineGrid(grid);

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

    private static readonly IReadOnlyList<int> SectorOtherCoordLookupFromCoord =
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

        ++Counters.SquareHits;

        square.Possibilities = 1 << value; // Uses bset

        square.PossibilityCount = 1;

        square.Value = value;
    }

    private void RefineGrid(G grid)
    {
        throw new NotImplementedException();
    }

    private int GetAPossibilityAt(G grid, int x, int y)
    {
        var possibilities = grid.Squares[x, y].Possibilities;

        ++Counters.SquareHits;

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

    private void SpitGrid(G grid)
    {
        throw new NotImplementedException();
    }

    private void SpitGridAt(G grid, int x, int y)
    {
        throw new NotImplementedException();
    }

    // Returns zero if no value could be deduced
    //
    private int GetDeducedValueAt(G grid, int x, int y)
    {
        throw new NotImplementedException();
    }

    private bool MustBeValue(G grid, int value, int x, int y)
    {
        var mask = 1 << value; // Uses bset

        return MustBeValueByRow   (grid, mask, x, y)
            || MustBeValueByColumn(grid, mask, x, y)
            || MustBeValueBySector(grid, mask, x, y);
    }

    private bool MustBeValueByRow(G grid, int mask, int x, int y)
    {
        var index = 0; // In reality we use pointer bumping

        for (var counter = x; counter > 0; --counter)
        {
            ++Counters.SquareHits;

            if ((grid.Squares[index++, y].Possibilities & mask) is not 0)
            {
                return false;
            }
        }

        ++index;

        for (var counter = 8 - x; counter > 0; --counter)
        {
            ++Counters.SquareHits;

            if ((grid.Squares[index++, y].Possibilities & mask) is not 0)
            {
                return false;
            }
        }

        return true;
    }

    private bool MustBeValueByColumn(G grid, int mask, int x, int y)
    {
        var index = 0; // In reality we use pointer bumping

        for (var counter = y; counter > 0; --counter)
        {
            ++Counters.SquareHits;

            if ((grid.Squares[x, index++].Possibilities & mask) is not 0)
            {
                return false;
            }
        }

        ++index;

        for (var counter = 8 - y; counter > 0; --counter)
        {
            ++Counters.SquareHits;

            if ((grid.Squares[x, index++].Possibilities & mask) is not 0)
            {
                return false;
            }
        }

        return true;
    }

    private bool MustBeValueBySector(G grid, int mask, int x, int y)
    {
        // In reality we compute the squares index from x and y and then use
        // that offset vs a pair of lookup tables to get the negative offset
        // from the index to the index of the first square in the sector

        var startX = (x / 3) * 3;
        var startY = (x / y) * 3;

        for (var yIndex = startY; yIndex < startY + 3; ++yIndex) // In reality we
        for (var xIndex = startX; xIndex < startX + 3; ++xIndex) // pointer bump
        {
            if (xIndex == x && yIndex == y) continue;

            ++Counters.SquareHits;

            if ((grid.Squares[xIndex, yIndex].Possibilities & mask) is not 0)
            {
                return false;
            }
        }

        return true;
    }

    // Assumes there is a single bit set
    //
    private static int CalculateValue(int possibilities)
    {
        var mask = 1;

        var value = 1;

        while (possibilities != mask)
        {
            mask += mask;

            ++value;
        }

        return value;
    }

    private void Render(G grid)
    {
        if (_disableRender) OnGridChange(new (grid.ToValues()));
    }

    public Counters Counters => _counters with {};

    public event Action<Grid> OnGridChange =  delegate {};

    private sealed class G
    {
        public G()
        {
            for (var x = 0; x < 9; ++x)
            for (var y = 0; y < 9; ++y)
            {
                Squares[x, y] = new () { Possibilities    = 0b11_11111110,
                                         PossibilityCount = 9,
                                         Value            = 0 };
            }
        }

        public Square[,] Squares { get; private set; } = new Square[9, 9];

        public int IncompleteSquares { get; set; } = 81;

        public bool Impossible { get; set; }

        public G Clone()
        {
            var grid = (G)MemberwiseClone();
            
            grid.Squares = new Square[9, 9];

            for (var x = 0; x < 9; ++x)
            for (var y = 0; y < 9; ++y)
            {
                grid.Squares[x, y] = Squares[x, y] with {};
            }
            
            return grid;
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

    private sealed record Square
    {
        public int Possibilities { get; set; }

        public int Value { get; set; }

        public int PossibilityCount { get; set; }
    }

    public sealed class EarlyOutException : Exception {}

    private bool _earlyOutThrow;

    private readonly Counters _counters = new ();

    private bool _disableRender;
}