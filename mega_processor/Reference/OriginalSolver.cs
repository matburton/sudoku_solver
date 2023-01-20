
namespace Megaprocessor.Reference.SudokuSolver;

using static BitInstructions;

internal sealed class OriginalSolver : ISolver
{
    public Grid Solve(Grid puzzle)
    {
        throw new NotImplementedException();
    }
    
    private void SetHintAt(G grid, int value, int x, int y)
    {
        var possibilities = grid.SquareBits[x, y];

        if (!BitClear(ref possibilities, value))
        {
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
        throw new NotImplementedException();
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

        grid.SquareBits[x, y] = 1 << value; // Uses bset

        ++Counters.SquareHits;
    }

    private void RefineGrid(G grid)
    {
        throw new NotImplementedException();
    }

    private int GetAPossibilityAt(G grid, int x, int y)
    {
        var possibilities = grid.SquareBits[x, y];

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

    public Counters Counters => _counters with {};

    public event Action<Grid> OnGridChange =  delegate {};

    private sealed class G
    {
        public G()
        {
            for (var x = 0; x < 9; ++x)
            for (var y = 0; y < 9; ++y)
            {
                SquareBits[x, y] = 0b11_11111110;
            }
        }

        public int[,] SquareBits { get; init; } = new int[9, 9];

        public int IncompleteSquares { get; set; } = 81;

        public bool Impossible { get; set; }

        public G Clone() => new ()
            { SquareBits        = (int[,])SquareBits.Clone(),
              IncompleteSquares = IncompleteSquares,
              Impossible        = Impossible };
    }

    public sealed class ImpossibleException : Exception {}

    private readonly Counters _counters = new ();
}