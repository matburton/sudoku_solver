
namespace MegaProcessor.Jack.VMTranslator.Console.Domain;

internal sealed class VirtualFunction
{
    public VirtualFunction(string label,
                           IEnumerable<VirtualInstruction> instructions)
    {
        Label = label;

        Instructions = instructions.ToArray();

        var stackCommands = Instructions
                           .Where(i => i.Command is "push" or "pop")
                           .ToArray();

        int GetMaxValue(string memorySegment) => stackCommands
           .Where(i => i.SegmentOrLabel == memorySegment)
           .Select(i => i.Value + 1)
           .Max() ?? 0;

        // Hack: Assumes all arguments are used, not always true
        //
        ArgumentCount = GetMaxValue("argument");

        LocalCount = GetMaxValue("local");

        TempCount = GetMaxValue("temp");
    }

    public string Label { get; }

    public IReadOnlyList<VirtualInstruction> Instructions { get; }

    // Hack: Assumes all arguments are used, not always true
    //
    public int ArgumentCount { get; }

    public int LocalCount { get; }

    public int TempCount { get; }
}