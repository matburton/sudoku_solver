
using System.Collections.Generic;

namespace SudokuSolver.Core
{
    public static class Solver
    {
        private static void SetValueAt(Grid grid, Coords coords, int value)
        {
            grid.SetSquareValue(coords, value);
            
            RemovePossibilitiesRelatedTo(grid, coords, value);
        }

        private static void RemovePossibilitiesRelatedTo(Grid grid,
                                                         Coords coords,
                                                         in int value)
        {
            for (var x = 0; x < grid.Dimension; ++x)
            {
                if (x != coords.X)
                {
                    RemovePossibilityAt(grid, (x, coords.Y), value);
                }
            }
            
            for (var y = 0; y < grid.Dimension; ++ y)
            {
                if (y != coords.Y)
                {
                    RemovePossibilityAt(grid, (coords.X, y), value);
                }
            }
            
            int Start(int i) => i / grid.SectorDimension * grid.SectorDimension;
            
            Coords start = (Start(coords.X), Start(coords.Y));
            
            Coords end = (start.X + grid.SectorDimension,
                          start.Y + grid.SectorDimension);

            for (var y = start.Y; y < end.Y; ++y)
            for (var x = start.X; x < end.X; ++x)
            {
                if (x != coords.X && y != coords.Y)
                {
                    RemovePossibilityAt(grid, (x, y), value);
                }
            }
        }

        private static void RemovePossibilityAt(Grid grid,
                                                Coords coords,
                                                int value)
        {
            if (!grid.GetSquare(coords).HasPossibility(value)) return;
            
            value = grid.RemoveSquarePossibility(coords, value).Value;
            
            if (value != 0) RemovePossibilitiesRelatedTo(grid, coords, value);
        }
        
        private static int GetDeducedValueAt(Grid grid, Coords coords)
        {
            var square = grid.GetSquare(coords);
            
            // ReSharper disable once InvertIf
            if (square.PossibilityCount > 1)
            {
                for (var value = 1; value <= grid.Dimension; ++ value)
                {
                    if (   square.HasPossibility(value)
                        && grid.MustBeValue(coords, value))
                    {
                        return value;
                    }
                }
            }
            
            return 0;
        }
        
        private static void RefineGrid(Grid grid)
        {
            Coords current = (0, 0), last = (0, 0);
            
            do
            {
                var value = GetDeducedValueAt(grid, current);
                
                if (value != 0)
                {
                    SetValueAt(grid, current, value);
                    
                    if (!grid.IsPossible) return;
                    
                    last = current;
                }
                
                current.X += 1;

                // ReSharper disable once InvertIf
                if (grid.Dimension == current.X)
                {
                    current = (0, current.Y + 1);
                    
                    if (grid.Dimension == current.Y) current.Y = 0;
                }
            }
            while (current != last);
        }
        
        private static void SplitFirstGridToFront(IList<Grid> grids,
                                                  Counters counters)
        {
            Coords best = (0, 0);
            
            var bestCount = 0;
            
            var grid = grids[0];
            
            for (var y = 0; y < grid.Dimension; ++y)
            for (var x = 0; x < grid.Dimension; ++x)
            {
                var count = grid.GetSquare((x, y)).PossibilityCount;
                
                // ReSharper disable once InvertIf
                if (count > 1 && (bestCount is 0 || count < bestCount))
                {
                    bestCount = count;
                    
                    best = (x, y);
                }
            }

            var value = grid.GetSquare(best).GetAPossibility();

            var clone = grid.Clone();
            
            ++counters.GridSplits;

            RemovePossibilityAt(grid, best, value);
            
            if (!grid.IsPossible)
            {
                ++counters.ImpossibleGrids;
                
                grids.RemoveAt(0);
            }
            
            SetValueAt(clone, best, value);
            
            if (clone.IsPossible) grids.Insert(0, clone);
            else ++counters.ImpossibleGrids;
        }
        
        public static void AdvanceSolving(IList<Grid> grids, Counters counters)
        {
            if (grids.Count is 0) return;
            
            var grid = grids[0];
            
            if (!grid.IsPossible)
            {
                ++counters.ImpossibleGrids;
                
                grids.RemoveAt(0);
                
                if (grids.Count is 0) return;
            }
            
            RefineGrid(grid);
            
            if (!grid.IsComplete && grid.IsPossible)
            {
                SplitFirstGridToFront(grids, counters);
            }
        }
    }
}