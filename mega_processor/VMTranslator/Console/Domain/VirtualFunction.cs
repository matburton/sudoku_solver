
namespace MegaProcessor.Jack.VMTranslator.Console.Domain;

internal sealed class VirtualFunction
{
    public VirtualFunction(string label,
                           IEnumerable<VirtualInstruction> instructions)
    {
        Label = label;

        Instructions = instructions.ToArray();
    }

    public string Label { get; }

    public IReadOnlyList<VirtualInstruction> Instructions { get; }
}