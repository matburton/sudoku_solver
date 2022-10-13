
namespace MegaProcessor.Jack.VMTranslator.Console.Domain;

internal sealed record VirtualInstruction(string Command,
                                          string? SegmentOrLabel,
                                          int? Value);