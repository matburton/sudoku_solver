
using System;
using System.Runtime.Intrinsics.X86;

namespace SudokuSolver.Core
{
    public sealed class Grid
    {
        public Grid(int sectorDimension)
        {
            if (sectorDimension is <= 0 or > 8)
            {
                throw new ArgumentOutOfRangeException
                    (nameof(sectorDimension), "Must be 1 to 8 inclusive");
            }
            
            SectorDimension = sectorDimension;
            
            Dimension = sectorDimension * sectorDimension;

            m_IncompleteSquares = Dimension * Dimension;
            
            m_Squares = new Square[Dimension, Dimension];
            
            var bits = Bmi1.X64.GetMaskUpToLowestSetBit(1UL << Dimension - 1);

            for (var x = 0; x < Dimension; ++x)
            for (var y = 0; y < Dimension; ++y)
            {
                m_Squares.SetValue(new Square { Bits = bits }, x, y);
            }
        }
        
        public Grid Clone()
        {
            var grid = (Grid)MemberwiseClone();
            
            grid.m_Squares = (Square[,])m_Squares.Clone();
            
            return grid;
        }
        
        public int SectorDimension { get; }

        public int Dimension { get; }
        
        public bool IsPossible => m_ImpossibleSquares is 0;
        
        public bool IsComplete => m_IncompleteSquares is 0;
        
        public Square GetSquare(Coords coords) => m_Squares[coords.X, coords.Y];
        
        public void SetSquareValue(Coords coords, int value)
        {
            var possibilityCount = m_Squares[coords.X, coords.Y]
                                  .PossibilityCount;
            
            if (possibilityCount is 0) m_ImpossibleSquares -= 1;
            if (possibilityCount != 1) m_IncompleteSquares -= 1;
            
            m_Squares[coords.X, coords.Y] = Square.FromValue(value);
        }

        public Square RemoveSquarePossibility(Coords coords, int value)
        {
            var square = m_Squares[coords.X, coords.Y]
                       = m_Squares[coords.X, coords.Y].WithoutPossibility(value);

            var possibilityCount = square.PossibilityCount;
            
            // ReSharper disable once ConvertIfStatementToSwitchStatement
            if (possibilityCount is 0)
            {
                m_ImpossibleSquares += 1;
                m_IncompleteSquares += 1;
            }
            else if (possibilityCount is 1)
            {
                m_IncompleteSquares -= 1;
            }
            
            return square;
        }

        public bool MustBeValue(Coords coords, int value)
        {
            var mask = Square.GetMask(value);

            return MustBeValueByRow   (coords, mask)
                || MustBeValueByColumn(coords, mask)
                || MustBeValueBySector(coords, mask);
        }
        
        public override string ToString() => this.ToGridString();

        private bool MustBeValueByRow(Coords coords, ulong mask)
        {
            for (var x = 0; x < Dimension; ++x)
            {
                if (x != coords.X && m_Squares[x, coords.Y].MaskMatch(mask))
                {
                    return false;
                }
            }
            
            return true;
        }
        
        private bool MustBeValueByColumn(Coords coords, ulong mask)
        {
            for (var y = 0; y < Dimension; ++y)
            {
                if (y != coords.Y && m_Squares[coords.X, y].MaskMatch(mask))
                {
                    return false;
                }
            }
            
            return true;
        }
        
        private bool MustBeValueBySector(Coords coords, ulong mask)
        {
            var startX = coords.X / SectorDimension * SectorDimension;
            var startY = coords.Y / SectorDimension * SectorDimension;
            
            var endX = startX + SectorDimension;
            var endY = startY + SectorDimension;

            for (var x = startX; x < endX; ++x)
            for (var y = startY; y < endY; ++y)
            {
                if (x == coords.X && y == coords.Y) continue;
                
                if (m_Squares[x, y].MaskMatch(mask)) return false;
            }
            
            return true;
        }
        
        private int m_ImpossibleSquares;
        
        private int m_IncompleteSquares;
        
        private Square[,] m_Squares;
    }
}