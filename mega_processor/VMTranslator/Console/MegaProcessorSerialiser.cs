
using MegaProcessor.Jack.VMTranslator.Console.Domain;

namespace MegaProcessor.Jack.VMTranslator.Console;

internal sealed class MegaProcessorSerialiser
{
    public static IEnumerable<string> ToAssembly(VirtualFunction function)
    {
        string? previousLine = null;

        foreach (var line in ToRawAssembly(function))
        {
            if (   line.Contains("pop  r1;")
                && previousLine?.Contains("push r1;") is true)
            {
                previousLine = null;

                continue;
            }

            if (previousLine is not null) yield return previousLine;

            previousLine = line;
        }

        if (previousLine is not null) yield return previousLine;
    }

    public static IEnumerable<string> ToRawAssembly
        (VirtualFunction function)
    {
        yield return string.Empty;

        yield return ToAssemblyFunctionLabel($"{function.Label}: // {function.Label}");

        if (function.UsesThat)
        {
            yield return "        addi sp, #-2;";
        }

        yield return "        move r0, sp;";

        if (function.ArgumentCount > 0)
        {
            yield return "        push r1;";
        }

        var localTempCount = function.LocalCount + function.TempCount;

        if (localTempCount > 0)
        {
            yield return $"        addi sp, #-{localTempCount * 2};";
        }

        foreach (var virtualInstruction in function.Instructions)
        {
            if (virtualInstruction.Command is "label")
            {
                yield return $"    {ToAssemblyGotoLabel(function.Label, virtualInstruction.SegmentOrLabel!)}:";

                yield return "        nop;"; // TODO: Needed?

                continue;
            }

            var lines = ToAssemblyLines(function, virtualInstruction)
                       .Select(l => $"        {l};")
                       .ToArray();

            if (lines.Any())
            {
                lines[0] += $" // {virtualInstruction.Command}";

                if (virtualInstruction.SegmentOrLabel is not null)
                {
                    lines[0] += $" {virtualInstruction.SegmentOrLabel}";
                }

                if (virtualInstruction.Value is not null)
                {
                    lines[0] += $" {virtualInstruction.Value}";
                }
            }

            foreach (var line in lines) yield return line;
        }
    }

    private static IEnumerable<string> ToAssemblyLines
        (VirtualFunction function,
         VirtualInstruction virtualInstruction)
    {
        return virtualInstruction.Command switch
        {
            "add" => new [] { "pop  r1",
                              "pop  r2",
                              "add  r1, r2",
                              "push r1" },

            "and" => new [] { "pop  r1",
                              "pop  r2",
                              "and  r1, r2",
                              "push r1" },

            "call" => ToCall(virtualInstruction),

            "eq" => new [] { "pop  r1",
                             "pop  r2",
                             "ld.w r3, #-1",
                             "cmp  r1, r2",
                             "beq  $+3",
                             "inc  r3",
                             "push r3" },

            "goto" => new []
                { $"jmp  {ToAssemblyGotoLabel(function.Label, virtualInstruction.SegmentOrLabel!)}" },

            "gt" => new [] { "pop  r1",
                             "pop  r2",
                             "ld.w r3, #-1",
                             "cmp  r2, r1",
                             "bgt  $+3",
                             "inc  r3",
                             "push r3" },

            "if-goto" => new []
                { "pop  r1", // This could be 'optimised' out
                  "test r1",
                  $"bne  {ToAssemblyGotoLabel(function.Label, virtualInstruction.SegmentOrLabel!)}" },

            "lt" => new [] { "pop  r1",
                             "pop  r2",
                             "ld.w r3, #-1",
                             "cmp  r2, r1",
                             "blt  $+3",
                             "inc  r3",
                             "push r3" },

            "not" => new [] { "pop  r1",
                              "inv  r1",
                              "push r1" },

            "or" => new [] { "pop  r1",
                             "pop  r2",
                             "or   r1, r2",
                             "push r1" },

            "pop" => ToPopAssemblyLines(function, virtualInstruction),

            "push" => ToPushAssemblyLines(function, virtualInstruction),

            "sub" => new [] { "pop  r1",
                              "pop  r2",
                              "sub  r2, r1",
                              "move r1, r2",
                              "push r1" },

            "return" => ToReturn(function),

            var c => throw new Exception($"Unsupported command '{c}'")
        };
    }

    private static IEnumerable<string> ToCall
        (VirtualInstruction virtualInstruction)
    {
        if (virtualInstruction.Value > 0)
        {
            yield return $"ld.w r1, (sp+{(virtualInstruction.Value - 1) * 2})";
            yield return $"st.w (sp+{(virtualInstruction.Value - 1) * 2}), r0";
        }
        else
        {
            yield return "push r0";
        }

        yield return  $"jsr  {ToAssemblyFunctionLabel(virtualInstruction.SegmentOrLabel!)}";

        if (virtualInstruction.Value > 0)
        {
            yield return $"ld.w r0, (sp+{(virtualInstruction.Value - 1) * 2})";
            yield return $"addi sp, #{virtualInstruction.Value * 2}";
        }
        else
        {
            yield return "pop  r0";
        }

        yield return  "push r1";
    }

    private static IEnumerable<string> ToReturn
        (VirtualFunction function)
    {
        yield return "pop  r1";
        yield return "move sp, r0";

        if (function.UsesThat)
        {
            yield return "addi sp, #2";
        }

        yield return "ret";
    }

    private static IEnumerable<string> ToPopAssemblyLines
        (VirtualFunction function,
         VirtualInstruction virtualInstruction)
    {
        return virtualInstruction.SegmentOrLabel switch
        {
            "argument" => new []
                { "pop  r1",
                  $"ld.w r3, #{function.GetArgumentOffset(virtualInstruction.Value!.Value)}",
                  "add  r3, r0",
                  "st.w (r3), r1" },

            "local" => new []
                { "pop  r1",
                  $"ld.w r3, #{function.GetLocalOffset(virtualInstruction.Value!.Value)}",
                  "add  r3, r0",
                  "st.w (r3), r1" },

            "pointer" => Array.Empty<string>(),

            "temp" => new []
                { "pop  r1",
                  $"ld.w r3, #{function.GetTempOffset(virtualInstruction.Value!.Value)}",
                  "add  r3, r0",
                  "st.w (r3), r1" },

            "that" => Array.Empty<string>(),

            var s => throw new Exception
                ($"Unsupported pop memory segment '{s}'")
        };
    }

    private static IEnumerable<string> ToPushAssemblyLines
        (VirtualFunction function,
         VirtualInstruction virtualInstruction)
    {
        return virtualInstruction.SegmentOrLabel switch
        {
            "constant" => new [] { $"ld.w r1, #{virtualInstruction.Value}",
                                   "push r1" },

            "argument" => new []
                { $"ld.w r3, #{function.GetArgumentOffset(virtualInstruction.Value!.Value)}",
                  "add  r3, r0",
                  "ld.w r1, (r3)",
                  "push r1" },

            "local" => new []
                { $"ld.w r3, #{function.GetLocalOffset(virtualInstruction.Value!.Value)}",
                  "add  r3, r0",
                  "ld.w r1, (r3)",
                  "push r1" },

            "temp" => new []
                { "ld.w r3, #{function.GetTempOffset(virtualInstruction.Value!.Value)}",
                  "add  r3, r0",
                  "ld.w r1, (r3)",
                  "push r1" },

            "that" => Array.Empty<string>(),

            var s => throw new Exception
                ($"Unsupported push memory segment '{s}'")
        };
    }

    private static string ToAssemblyGotoLabel(string functionLabel,
                                              string label)
    {
        return $"{ToAssemblyFunctionLabel(functionLabel)}_{label}";
    }

    private static string ToAssemblyFunctionLabel(string label) =>
        label.Replace('.', '_');
}