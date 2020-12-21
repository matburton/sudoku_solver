
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
            
            var (startX, startY) = (Start(coords.X), Start(coords.Y));
            
            var (endX, endY) = (startX + grid.SectorDimension,
                                startY + grid.SectorDimension);

            for (var y = startY; y < endY; ++y)
            for (var x = startX; x < endX; ++x)
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
            var (x, y, lastX, lastY) = (0, 0, 0, 0);
            
            do
            {
                var value = GetDeducedValueAt(grid, (x, y));
                
                if (value != 0)
                {
                    SetValueAt(grid, (x, y), value);
                    
                    if (!grid.IsPossible) return;
                    
                    (lastX, lastY) = (x, y);
                }
                
                x += 1;

                // ReSharper disable once InvertIf
                if (grid.Dimension == x)
                {
                    (x, y) = (0, y + 1);
                    
                    if (grid.Dimension == y) y = 0;
                }
            }
            while (x != lastX || y != lastY);
        }
        
        private static void SplitFirstGridToFront(IList<Grid> grids,
                                                  Counters counters)
        {
            var (bestCount, bestX, bestY) = (0, 0, 0);
            
            var grid = grids[0];
            
            for (var y = 0; y < grid.Dimension; ++y)
            for (var x = 0; x < grid.Dimension; ++x)
            {
                var count = grid.GetSquare((x, y)).PossibilityCount;
                
                if (count > 1 && (bestCount is 0 || count < bestCount))
                {
                    (bestCount, bestX, bestY) = (count, x, y);
                }
            }
            
            Coords coords = (bestX, bestY);
            
            var value = grid.GetSquare(coords).GetAPossibility();

            var clone = grid.Clone();
            
            ++counters.GridSplits;

            RemovePossibilityAt(grid, coords, value);
            
            if (!grid.IsPossible)
            {
                ++counters.ImpossibleGrids;
                
                grids.RemoveAt(0);
            }
            
            SetValueAt(clone, coords, value);
            
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