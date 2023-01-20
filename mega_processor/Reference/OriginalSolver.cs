
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

        if (!BitClear(ref possibilities, value))
        {
            grid.Squares[x, y].Value = value;

            grid.Impossible = true;
        }
        else if (possibilities is not 0)
        {
            SetValueAt(grid, value, x, y);
        }

        ++Counters.SquareHits;
    }

    private void SetValueAt(G grid, int value, int x, int y)
    {
        SetSquareValue(grid, value, x, y);

        Render(grid);

        RemovePossibilitiesRelatedTo(grid, value, x, y);
    }

    private void RemovePossibilityAt(G grid, int value, int x, int y)
    {
        throw new NotImplementedException();
    }

    private void RemovePossibilitiesRelatedTo(G grid, int value, int x, int y)
    {
        throw new NotImplementedException();
    }

    private void RemovePossibilitiesRelatedToRow(G grid, int value, int x, int y)
    {
        throw new NotImplementedException();
    }

    private void RemovePossibilitiesRelatedToColumn(G grid, int value, int x, int y)
    {
        throw new NotImplementedException();
    }

    private void RemovePossibilitiesRelatedToSector(G grid, int value, int x, int y)
    {
        throw new NotImplementedException();
    }

    /// <remarks>Assumes the square has the value and had others</remarks>
    ///
    private void SetSquareValue(G grid, int value, int x, int y)
    {
        --grid.IncompleteSquares;

        var square = grid.Squares[x, y];

        square.Possibilities = 1 << value; // Uses bset

        square.PossibilityCount = 1;

        square.Value = value;

        ++Counters.SquareHits;
    }

    private void RefineGrid(G grid)
    {
        throw new NotImplementedException();
    }

    private int GetAPossibilityAt(G grid, int x, int y)
    {
        var possibilities = grid.Squares[x, y].Possibilities;

        var value = 9;

        for (; value > 0; --value)
        {
            if (BitTest(possibilities, value))
            {
                break;
            }
        }

        ++Counters.SquareHits;

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

    private void GetDeducedValueAt(G grid, int x, int y)
    {
        throw new NotImplementedException();
    }

    private bool MustBeValue(G grid, int value, int x, int y)
    {
        throw new NotImplementedException();
    }

    private bool MustBeValueByRow(G grid, int mask, int x, int y)
    {
        throw new NotImplementedException();
    }

    private bool MustBeValueByColumn(G grid, int mask, int x, int y)
    {
        throw new NotImplementedException();
    }

    private bool MustBeValueBySector(G grid, int mask, int x, int y)
    {
        throw new NotImplementedException();
    }

    /// <remarks>Assumes there is a single bit set</remarks>
    ///
    private static int CalculateValue(short possibilities)
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

    private readonly Counters _counters = new ();

    private bool _disableRender;
}