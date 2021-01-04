
namespace SudokuSolver.Core
{
    public readonly ref struct Coords
    {
        public static implicit operator Coords((int x, int y) t) =>
            new () { X = t.x, Y = t.y };

        public int X { get; private init; }

        public int Y { get; private init; }
    }
}