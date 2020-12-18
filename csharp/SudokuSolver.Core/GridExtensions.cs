
using System.Collections.Concurrent;
using System.Text;

namespace SudokuSolver.Core
{
    internal static class GridExtensions
    {
        public static string ToGridString(this Grid grid)
        {
            var lineLength =
                grid.Dimension * 2 + (grid.SectorDimension - 1) * 2 + 1;
            
            var stringBuilder = new StringBuilder
                (lineLength * (grid.Dimension + grid.SectorDimension - 1));
            
            stringBuilder.AppendLine();
            
            var dividerLine = DividerLines.GetOrAdd
                (grid.SectorDimension,
                 _ => CreateDividerLine(grid, lineLength));
            
            for (var y = 1; y <= grid.Dimension; ++y)
            {
                AppendRow(stringBuilder, grid, y - 1);
                
                // ReSharper disable once InvertIf
                if (y != grid.Dimension)
                {
                    stringBuilder.AppendLine();
                    
                    if (y % grid.SectorDimension is 0)
                    {
                        stringBuilder.Append(dividerLine);
                    }
                }
            }
            
            return stringBuilder.ToString();
        }
        
        private static void AppendRow(StringBuilder stringBuilder,
                                      Grid grid,
                                      int y)
        {
            for (var x = 1; x <= grid.Dimension; ++x)
            {
                stringBuilder.Append(FormatValue(grid, (x - 1, y)));

                // ReSharper disable once InvertIf
                if (x != grid.Dimension)
                {
                    stringBuilder.Append(" ");
                    
                    if (x % grid.SectorDimension is 0)
                    {
                        stringBuilder.Append("| ");
                    }
                }
            }
        }
        
        private static char FormatValue(Grid grid, Coords coords)
        {
            var value = grid.GetSquareValue(coords);
            
            char FromBase(char c, int offset = 0) => (char)(c + value - offset);
            
            if (value is 0)
            {
                return grid.GetPossibilityCount(coords) switch { 0 => '!',
                                                                 _ => '.' };
            }
            
            if (grid.SectorDimension <= 3) return FromBase('0');
            
            return value switch { < 11 => FromBase('0', 1),
                                  < 37 => FromBase('A', 11),
                                  < 63 => FromBase('a', 37),
                                  63   => '$',
                                  _    => '@' };
        }
        
        private static string CreateDividerLine(Grid grid, int lineLength)
        {
            var stringBuilder = new StringBuilder(lineLength);
            
            for (var x = 1; x <= grid.Dimension; ++x)
            {
                if (grid.Dimension == x)
                {
                    stringBuilder.AppendLine("-");
                }
                else
                {
                    stringBuilder.Append("--");
                    
                    if (x % grid.SectorDimension is 0)
                    {
                        stringBuilder.Append("+-");
                    }
                }
            }
            
            return stringBuilder.ToString();
        }
        
        private static readonly ConcurrentDictionary<int, string> DividerLines = new ();
    }
}