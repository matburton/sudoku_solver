
using MegaProcessor.Jack.VMTranslator.Console.Domain;

namespace MegaProcessor.Jack.VMTranslator.Console;

internal sealed class MegaProcessorSerialiser
{
    public static IEnumerable<string> ToAssembly(VirtualFunction function)
    {
        yield return string.Empty;

        yield return ToAssemblyFunctionLabel($"{function.Label}: // {function.Label}");

        yield return "        move r0, sp;";
        yield return "        move r3, r0;";
        yield return $"        addi sp, #-{(function.LocalCount + function.TempCount) * 2};";

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
                              "pop  r0",
                              "add  r1, r0",
                              "push r1" },

            "and" => new [] { "pop  r1",
                              "pop  r0",
                              "and  r1, r0",
                              "push r1" },

            "call" => new [] { "push r3",
                               $"jsr  {ToAssemblyFunctionLabel(virtualInstruction.SegmentOrLabel!)}",
                               "pop  r3",
                               $"addi sp, #{virtualInstruction.Value * 2}",
                               "push r1" },

            "eq" => new [] { "pop  r1",
                             "pop  r0",
                             "ld.w r2, #-1",
                             "cmp  r1, r0",
                             "beq  $+3",
                             "inc  r2",
                             "push r2" },

            "goto" => new [] { $"jmp  {ToAssemblyGotoLabel(function.Label, virtualInstruction.SegmentOrLabel!)}" },

            "gt" => new [] { "pop  r1",
                             "pop  r0",
                             "ld.w r2, #-1",
                             "cmp  r0, r1",
                             "bgt  $+3",
                             "inc  r2",
                             "push r2" },

            "if-goto" => new [] { "pop  r1",
                                  $"bne  {ToAssemblyGotoLabel(function.Label, virtualInstruction.SegmentOrLabel!)}" },

            "lt" => new [] { "pop  r1",
                             "pop  r0",
                             "ld.w r2, #-1",
                             "cmp  r0, r1",
                             "blt  $+3",
                             "inc  r2",
                             "push r2" },

            "not" => new [] { "pop  r1",
                              "inv  r1",
                              "push r1" },

            "or" => new [] { "pop  r1",
                             "pop  r0",
                             "or   r1, r0",
                             "push r1" },

            "push" => ToPushAssemblyLines(function, virtualInstruction),

            "return" => new [] { "pop  r1",
                                 "move r0, r3",
                                 "move sp, r0",
                                 "ret" },

            _ => Array.Empty<string>()
        };
    }

    private static IEnumerable<string> ToPushAssemblyLines
        (VirtualFunction function,
         VirtualInstruction virtualInstruction)
    {
        return virtualInstruction.SegmentOrLabel switch
        {
            "constant" => new [] { $"ld.w r0, #{virtualInstruction.Value}",
                                   "push r0" },

            _ => Array.Empty<string>()
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