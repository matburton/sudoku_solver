
namespace Megaprocessor.Reference.SudokuSolver;

internal static class BitInstructions
{
    public static bool BitTest(int value, int index) =>
        (value & (1 << index)) is not 0;

    public static bool BitClear(ref int value, int index)
    {
        var wasSet = BitTest(value, index);

        value &= ~(1 << index);

        return wasSet;
    }
}