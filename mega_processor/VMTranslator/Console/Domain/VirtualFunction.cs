
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

    public bool UsesThat => Instructions
        .Where(i => i.Command is "pop" or "push")
        .Any(i => i.SegmentOrLabel is "that" or "pointer");

    public int GetArgumentOffset(int index)
    {
        if (index is 0) return -2;

        return 2 * (UsesThat ? ArgumentCount - index + 1
                             : ArgumentCount - index);
    }

    public int GetLocalOffset(int index) =>
        -2 * (ArgumentCount > 0 ? index + 2
                                : index + 1);

    public int GetTempOffset(int index)
    {
        if (ArgumentCount > 0) index += 1;

        return 2 * (-index - LocalCount - 1);
    }
}