
using static System.DateTimeOffset;

namespace SudokuSolver.Core
{
    public sealed class Counters
    {
        public long StartTime { get; } = UtcNow.ToUnixTimeMilliseconds();

        public int GridSplits { get; set; }
        
        public int ImpossibleGrids { get; set; }
        
        public int GridsLost { get; set; }
        
        public int Solutions { get; set; }
    }
}