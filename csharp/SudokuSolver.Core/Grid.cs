
using System;

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
            
            Array.Fill(m_Squares, new () { Bits = ulong.MaxValue });
        }
        
        public int SectorDimension { get; }

        public int Dimension { get; }
        
        public Grid Clone() => (Grid)MemberwiseClone();

        public void SetSquareValue(Coords coords, int value)
        {
            var index = ToIndex(coords);
            
            var possibilityCount = m_Squares[index].PossibilityCount;
            
            if (possibilityCount is 0) m_ImpossibleSquares -= 1;
            if (possibilityCount != 1) m_IncompleteSquares -= 1;
            
            m_Squares[index] = Square.FromValue(value);
        }
        
        public bool SquareHasPossibility(Coords coords, int value) =>
            m_Squares[ToIndex(coords)].HasPossibility(value);

        public void RemoveSquarePossibility(Coords coords, int value)
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
        }
        
        public int GetPossibilityCount(Coords coords) =>
            (int)m_Squares[ToIndex(coords)].PossibilityCount;

        /// <returns>
        /// 0 if the square has multiple possibilities or no possibilities
        /// </returns>
        ///
        public int GetSquareValue(Coords coords)
        {
            var square = m_Squares[ToIndex(coords)];
            
            if (square.PossibilityCount != 1) return 0;
            
            var value = 1;
            
            for (var mask = 1UL; value < Dimension; mask <<= 1, ++value)
            {
                if ((square.Bits & mask) != 0) return value;
            }
            
            return value;
        }
        
        public bool IsPossible => m_ImpossibleSquares is 0;
        
        public bool IsComplete => m_IncompleteSquares is 0;

        public override string ToString() => this.ToGridString();

        public bool MustBeValue(Coords coords, int value)
        {
            var mask = Square.GetMask(value);

            return MustBeValueByRow   (coords, mask)
                || MustBeValueByColumn(coords, mask)
                || MustBeValueBySector(coords, mask);
        }

        private bool MustBeValueByRow(Coords coords, ulong mask)
        {
            for (var index = ToIndex((0, coords.Y)); index < Dimension; ++index)
            {
                if (index != coords.X && m_Squares[index].MaskMatch(mask))
                {
                    return false;
                }
            }
            
            return true;
        }
        
        private bool MustBeValueByColumn(Coords coords, ulong mask)
        {
            var index = coords.X;

            for (var i = 0; i < Dimension; ++i, index += Dimension)
            {
                if (i != coords.Y && m_Squares[index].MaskMatch(mask))
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

            for (var i = 0; i < Dimension; ++i)
            {
                if (index != ignoreIndex && m_Squares[index].MaskMatch(mask))
                {
                    return false;
                }
                
                index += 1;
                
                if (index % SectorDimension is 0)
                {
                    index += Dimension - SectorDimension;
                }
            }
            
            return true;
        }
        
        private int ToIndex(Coords coords) => coords.Y * Dimension + coords.X;

        private int m_ImpossibleSquares;
        
        private int m_IncompleteSquares;
        
        private readonly Square[] m_Squares;
    }
}