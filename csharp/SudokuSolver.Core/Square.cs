
using System.Runtime.Intrinsics.X86;

namespace SudokuSolver.Core
{
    public readonly struct Square
    {
        public static Square FromValue(int value) =>
            new () { Bits = 1UL << value - 1 };

        public ulong Bits { get; init; }

        public ulong PossibilityCount => Popcnt.X64.PopCount(Bits);
        
        public bool HasPossibility(int value) => MaskMatch(GetMask(value));
        
        public Square WithoutPossibility(int value) =>
            new () { Bits = Bits & ~GetMask(value) };
        
        internal bool MaskMatch(ulong mask) => (Bits & mask) != 0;
        
        internal static ulong GetMask(int value) => 1UL << value - 1;
    }
}