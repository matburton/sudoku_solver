
using MegaProcessor.Jack.VMTranslator.Console;
using MegaProcessor.Jack.VMTranslator.Console.Domain;

foreach (var filePath in Directory.GetFiles(".", "*.vm"))
{
    File.WriteAllLines
        ($"{Path.GetFileNameWithoutExtension(filePath)}.asm",
         VirtualMachineParser
            .Parse(File.ReadAllLines(filePath))
            .Where(f => !IsStub(f))
            .SelectMany(MegaProcessorSerialiser.ToAssembly)); 
}

static bool IsStub(VirtualFunction function) =>
       function.Instructions.Count is 2
    && function.Instructions[0] is { Command: "push",
                                     SegmentOrLabel: "constant" }
    && function.Instructions[1] is { Command: "return" };