
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;

namespace SudokuSolver.Core
{
    public sealed class Counters
    {
        public Counters() => m_Stopwatch.Start();

        public int GridSplits { get; set; }
        
        public int ImpossibleGrids { get; set; }
        
        public int GridsLost { get; set; }
        
        public int Solutions { get; set; }
        
        public string ToString(IReadOnlyCollection<Grid> grids)
        {
            var stringBuilder = new StringBuilder();
            
            void Append(string? s = null) => stringBuilder.AppendLine(s);
            
            var e = m_Stopwatch.Elapsed;
            
            Append();
            Append($"Grids in memory:              {grids.Count}");
            Append($"Elapsed time:                 {e.TotalHours:00}:{e:mm\\:ss}");
            Append($"Grids created via splitting:  {GridSplits}");
            Append($"Impossible grids encountered: {ImpossibleGrids}");
            Append($"Grids lost due to low memory: {GridsLost}");

            stringBuilder.Append($"Solutions found:              {Solutions}");
            
            return stringBuilder.ToString();
        }
        
        private readonly Stopwatch m_Stopwatch = new ();
    }
}