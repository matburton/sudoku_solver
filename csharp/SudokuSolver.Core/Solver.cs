
namespace SudokuSolver.Core
{
    public sealed class Solver
    {
        private static int GetAPossibilityAt(Grid grid, Coords coords)
        {
            for (var value  = 1; value < grid.Dimension; ++value)
            {
                if (grid.SquareHasPossibility(coords, value)) return value;
            }
            
            return grid.Dimension;
        }
        
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
            
            var startX = coords.X / grid.SectorDimension * grid.SectorDimension;
            var startY = coords.Y / grid.SectorDimension * grid.SectorDimension;

            for (var y = startY; y < startY + grid.SectorDimension; ++y)
            for (var x = startX; x < startX + grid.SectorDimension; ++x)
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
            if (!grid.SquareHasPossibility(coords, value)) return;
            
            grid.RemoveSquarePossibility(coords, value);
            
            value = grid.GetSquareValue(coords);
            
            if (value != 0) RemovePossibilitiesRelatedTo(grid, coords, value);
        }
    }
}