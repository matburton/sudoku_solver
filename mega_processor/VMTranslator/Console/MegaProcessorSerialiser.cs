
using MegaProcessor.Jack.VMTranslator.Console.Domain;

namespace MegaProcessor.Jack.VMTranslator.Console;

internal sealed class MegaProcessorSerialiser
{
    public static IEnumerable<string> ToAssembly(VirtualFunction function)
    {
        yield return ToAssemblyFunctionLabel($"{function.Label}: // {function.Label}");

        yield return "        nop;"; // TODO: Needed?

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

        yield return string.Empty;
    }

    private static IEnumerable<string> ToAssemblyLines
        (VirtualFunction function,
         VirtualInstruction virtualInstruction)
    {
        return virtualInstruction.Command switch
        {
            "add" => new [] { "pop  r0",
                              "pop  r1",
                              "add  r0, r1",
                              "push r0" },

            "and" => new [] { "pop  r0",
                              "pop  r1",
                              "and  r0, r1",
                              "push r0" },

            "eq" => new [] { "pop  r0",
                             "pop  r1",
                             "cmp  r0, r1",
                             "andi ps, #0b100",
                             "move r0, sp",
                             "lsr  r0, #2",
                             "dec  r0",
                             "inv  r0",
                             "push r0" },

            "goto" => new [] { $"jmp  {ToAssemblyGotoLabel(function.Label, virtualInstruction.SegmentOrLabel!)}" },

            "not" => new [] { "pop  r0",
                              "inv  r0",
                              "push r0" },

            "or" => new [] { "pop  r0",
                             "pop  r1",
                             "or   r0, r1",
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