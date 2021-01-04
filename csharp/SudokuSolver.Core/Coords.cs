
namespace SudokuSolver.Core
{
    #pragma warning disable 660, 661
    public ref struct Coords
    {
        public static implicit operator Coords((int x, int y) t) =>
            new () { X = t.x, Y = t.y };

        public int X { get; set; }

        public int Y { get; set; }
        
        public static bool operator == (Coords a, Coords b) =>
            a.X == b.X && a.Y == b.Y;
        
        public static bool operator != (Coords a, Coords b) =>
            a.X != b.X || a.Y != b.Y;
    }
    #pragma warning restore 660, 661
}