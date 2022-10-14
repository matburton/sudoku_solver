
using MegaProcessor.Jack.VMTranslator.Console.Domain;

namespace MegaProcessor.Jack.VMTranslator.Console;

internal sealed class VirtualMachineParser
{
    public static IEnumerable<VirtualFunction> Parse
        (IEnumerable<string> lines)
    {
        string? label = null;

        var instructions = new List<VirtualInstruction>();

        foreach (var parts in lines.Select(l => l.Split(' ', 3)))
        {
            if (parts[0] is "function")
            {
                if (label is not null)
                {
                    yield return new VirtualFunction(label, instructions);

                    instructions.Clear();
                }

                label = parts[1];
            }
            else
            {
                int? value = parts.Skip(2).FirstOrDefault() is {} v
                           ? int.Parse(v) : null;

                instructions.Add(new (parts[0],
                                      parts.Skip(1).FirstOrDefault(),
                                      value));
            }
        }

        if (label is not null)
        {
            yield return new VirtualFunction(label, instructions);
        }
    }
}