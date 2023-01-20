
using NUnit.Framework;

namespace Megaprocessor.Reference.SudokuSolver;

using static BitInstructions; 

internal sealed class BitInstructionsTests
{
    [TestCase(0b1010, 1, ExpectedResult = true)]
    [TestCase(0b1010, 2, ExpectedResult = false)]
    public bool BitTest_returns_correctly(int value, int index) =>
        BitTest(value, index);

    [TestCase(0b1010, 1, ExpectedResult = true)]
    [TestCase(0b1010, 2, ExpectedResult = false)]
    public bool BitClear_returns_correctly(int value, int index) =>
        BitClear(ref value, index);

    [TestCase(0b1010, 1, ExpectedResult = 0b1000)]
    [TestCase(0b1010, 2, ExpectedResult = 0b1010)]
    public int BitClear_changes_value_correctly(int value, int index)
    {
        BitClear(ref value, index);

        return value;
    }
}