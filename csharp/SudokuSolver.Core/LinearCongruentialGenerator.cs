
namespace SudokuSolver.Core
{
    internal sealed class LinearCongruentialGenerator
    {
        public int Next(int exclusiveMaximum)
        {
            m_Bits = (1664525 * m_Bits + 1013904223) % 4294967296;
            
            return (int)(m_Bits % exclusiveMaximum);
        }
        
        private long m_Bits;
    }
}