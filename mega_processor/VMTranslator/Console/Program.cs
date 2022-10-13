
using MegaProcessor.Jack.VMTranslator.Console;

foreach (var filePath in Directory.GetFiles(".", "*.vm"))
{
    File.WriteAllLines
        ($"{Path.GetFileNameWithoutExtension(filePath)}.asm",
         VirtualMachineParser
            .Parse(File.ReadAllLines(filePath))
            .SelectMany(MegaProcessorSerialiser.ToAssembly)); 
}