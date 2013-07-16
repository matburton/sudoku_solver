
using System;
using System.IO;

using SudokuSolver.Core;

namespace SudokuSolver.Console
{
    public static class Program
    {
        static int Main(string[] arguments)
        {
            try
            {
                if (arguments.Length != 1)
                {
                    throw new Exception("1 file path argument expected");
                }

                var lines = File.ReadAllLines(arguments[0]);

                foreach (var solution in Batch.SolveLines(lines))
                {
                    System.Console.WriteLine(solution);
                }

                return 0;
            }
            catch (Exception exception)
            {
                while (exception != null)
                {
                    System.Console.Error.WriteLine(exception.Message);

                    exception = exception.InnerException;
                }

                return 1;
            }
        }
    }
}
