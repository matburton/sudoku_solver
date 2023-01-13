
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NUnit.Framework;

internal sealed class MakeLedRenderLookups
{
    [Test]
    public void MakeLookup()
    {
        var stringBuilder = new StringBuilder();

        stringBuilder.AppendLine("xToDigitLookupOffset:");

        stringBuilder.AppendLine($"    dw {string.Join(", ", Enumerable.Range(0, 9).Select(x => x * 92))};\n");

        stringBuilder.AppendLine("digitLookup: // Left side of 'screen'");

        foreach (var x in Enumerable.Range(0, 4))
        {
            var shift = x * 3 + 1;

            if (x > 2) shift += 2;

            stringBuilder.AppendLine($"    dw   0b{ToBinary(~(0b11 << shift))}; // Mask @ x = {x}");

            foreach (var value in Enumerable.Range(1, 9))
            {
                var digitBitmap = DitgitBitmaps[value - 1];

                stringBuilder.AppendLine($"    dw   0b{ToBinary(digitBitmap[0] << shift)}; // Value {value} @ {x}");

                foreach (var lineIndex in Enumerable.Range(1, 4))
                {
                    stringBuilder.AppendLine($"    dw   0b{ToBinary(digitBitmap[lineIndex] << shift)};");
                }
            }
        }

        stringBuilder.AppendLine("    // Middle of 'screen'");

        stringBuilder.AppendLine($"    dw   0b{ToBinary(~(0b11 << 7))}; // Mask @ x = 4");

        foreach (var value in Enumerable.Range(1, 9))
        {
            var digitBitmap = DitgitBitmaps[value - 1];

            stringBuilder.AppendLine($"    dw   0b{ToBinary(digitBitmap[0] << 7)}; // Value {value} @ 4");

            foreach (var lineIndex in Enumerable.Range(1, 4))
            {
                stringBuilder.AppendLine($"    dw   0b{ToBinary(digitBitmap[lineIndex] << 7)};");
            }
        }

        stringBuilder.AppendLine("    // Right side of 'screen'");

        foreach (var x in Enumerable.Range(5, 4))
        {
            var shift = (x - 5) * 3 + 2;

            if (x > 5) shift += 2;

            stringBuilder.AppendLine($"    dw   0b{ToBinary(~(0b11 << shift))}; // Mask @ x = {x}");

            foreach (var value in Enumerable.Range(1, 9))
            {
                var digitBitmap = DitgitBitmaps[value - 1];

                stringBuilder.AppendLine($"    dw   0b{ToBinary(digitBitmap[0] << shift)}; // Value {value} @ {x}");

                foreach (var lineIndex in Enumerable.Range(1, 4))
                {
                    stringBuilder.AppendLine($"    dw   0b{ToBinary(digitBitmap[lineIndex] << shift)};");
                }
            }
        }

        Console.WriteLine(stringBuilder);
    }

    private static readonly IReadOnlyList<IReadOnlyList<int>> DitgitBitmaps = new []
    {
        new [] { 0b10,
                 0b10,
                 0b10,
                 0b10,
                 0b10 },

        new [] { 0b11,
                 0b10,
                 0b11,
                 0b01,
                 0b11 },

        new [] { 0b11,
                 0b10,
                 0b11,
                 0b10,
                 0b11 },

        new [] { 0b01,
                 0b11,
                 0b11,
                 0b10,
                 0b10 },

        new [] { 0b11,
                 0b01,
                 0b11,
                 0b10,
                 0b11 },

        new [] { 0b11,
                 0b01,
                 0b11,
                 0b11,
                 0b11 },

        new [] { 0b11,
                 0b10,
                 0b10,
                 0b10,
                 0b10 },

        new [] { 0b11,
                 0b11,
                 0b11,
                 0b11,
                 0b11 },

        new [] { 0b11,
                 0b11,
                 0b11,
                 0b10,
                 0b10 }
    };

    [TestCase(0b0110, ExpectedResult = "0000000000000110")]
    [TestCase(0b0110, 8, ExpectedResult = "00000110")]
    public static string ToBinary(int word, int length = 16) =>
        new (Enumerable.Range(0, length)
                       .Reverse()
                       .Select(i => ((1 << i) & word) is 0 ? '0' : '1')
                       .ToArray());
}