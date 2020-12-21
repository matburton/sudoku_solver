
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
            
            var squareCount = Dimension * Dimension;
            
            m_IncompleteSquares = squareCount;
            
            m_Squares = new Square[squareCount];
            
            var bits = Bmi1.X64.GetMaskUpToLowestSetBit(1UL << Dimension - 1);
            
            Array.Fill(m_Squares, new () { Bits = bits });
        }
        
        public Grid Clone()
        {
            var grid = (Grid)MemberwiseClone();
            
            grid.m_Squares = (Square[])m_Squares.Clone();
            
            return grid;
        }
        
        public int SectorDimension { get; }

        public int Dimension { get; }
        
        public bool IsPossible => m_ImpossibleSquares is 0;
        
        public bool IsComplete => m_IncompleteSquares is 0;
        
        public Square GetSquare(Coords coords) => m_Squares[ToIndex(coords)];
        
        public void SetSquareValue(Coords coords, int value)
        {
            var index = ToIndex(coords);
            
            var possibilityCount = m_Squares[index].PossibilityCount;
            
            if (possibilityCount is 0) m_ImpossibleSquares -= 1;
            if (possibilityCount != 1) m_IncompleteSquares -= 1;
            
            m_Squares[index] = Square.FromValue(value);
        }

        public Square RemoveSquarePossibility(Coords coords, int value)
        {
            var index = ToIndex(coords);
            
            var square = m_Squares[index]
                       = m_Squares[index].WithoutPossibility(value);

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
            var index = ToIndex((0, coords.Y));
            
            for (var x = 0; x < Dimension; ++x)
            {
                if (x != coords.X && m_Squares[index + x].MaskMatch(mask))
                {
                    return false;
                }
            }
            
            return true;
        }
        
        private bool MustBeValueByColumn(Coords coords, ulong mask)
        {
            var index = coords.X;

            for (var y = 0; y < Dimension; ++y, index += Dimension)
            {
                if (y != coords.Y && m_Squares[index].MaskMatch(mask))
                {
                    return false;
                }
            }
            
            return true;
        }
        
        private bool MustBeValueBySector(Coords coords, ulong mask)
        {
            var ignoreIndex = ToIndex(coords);
            
            var index = ToIndex((coords.X / SectorDimension * SectorDimension,
                                 coords.Y / SectorDimension * SectorDimension));
            
            var bumpSize = Dimension - SectorDimension;

            for (var i = 0; i < SectorDimension; ++i, index += bumpSize)
            for (var j = 0; j < SectorDimension; ++j, ++index)
            {
                if (index != ignoreIndex && m_Squares[index].MaskMatch(mask))
                {
                    return false;
                }
            }
            
            return true;
        }
        
        private int ToIndex(Coords coords) => coords.Y * Dimension + coords.X;

        private int m_ImpossibleSquares;
        
        private int m_IncompleteSquares;
        
        private Square[] m_Squares;
    }
}