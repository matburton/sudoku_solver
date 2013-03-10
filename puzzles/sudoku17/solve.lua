
-- Augment the package search path
package.path = "../../lua/?.lua;" .. package.path

-- This will solve all the puzzels in the puzzles.txt file
-- Each line the the puzzles file should be a parse-able line
-- For each puzzle will write the following to the
-- results.csv file separated by commas:
--    - The puzzle line
--    - The solution line
--    - The time taken to find the first solution
--      in seconds and clock ticks
--    - The number of splits to find the first solution
--    - The time taken to check there are no other
--      solutions in seconds and clock ticks
--    - The number of splits to check there
--      are no other solutions

print("Evaluating all known 17 hint sudokus...")

require "sudoku.parsers"
require "sudoku.solvers"
require "sudoku.printers"

io.input ("puzzles.txt")
io.output("lua_results.csv")

local puzzleCount = 0

for puzzleLine in io.lines() do

   puzzleCount = puzzleCount + 1

   print("\nSolving puzzle number: " .. puzzleCount .. "\n" .. puzzleLine)
     
   local startToken = { time  = os.time(),
                        clock = os.clock() }
   
   local producer = sudoku.produceSolutions(sudoku.parseLine(puzzleLine))
     
   local dummy, solution, splitsToFirstSolution = coroutine.resume(producer)
   
   local firstToken = { time  = os.time(),
                        clock = os.clock() }
      
   if not solution then
      error("Did not find a solution to: " .. puzzleLine)
   end
      
   local dummy, solutionDummy, splitsToCheckNoMore = coroutine.resume(producer)
   
   local stopToken = { time  = os.time(),
                       clock = os.clock() }
           
   if solutionDummy then
      error("Found a second solution to: " .. puzzleLine)
   end
   
   local results = { puzzleLine,
                     sudoku.getStateLine(solution),
                     firstToken.time  - startToken.time,
                     firstToken.clock - startToken.clock,
                     splitsToFirstSolution,
                     stopToken.time  - startToken.time,
                     stopToken.clock - startToken.clock,
                     splitsToCheckNoMore }
      
   -- Write the results to the results file
   io.write(table.concat(results, ",") .. "\n")
   
   local consoleOutput = {}
   
   table.insert(consoleOutput, "\nSolution:")
   table.insert(consoleOutput, sudoku.getGridString(solution))
   table.insert(consoleOutput, "First solution found after:")
   table.insert(consoleOutput, "\t" .. firstToken.time  - startToken.time  .. "\tseconds")
   table.insert(consoleOutput, "\t" .. firstToken.clock - startToken.clock .. "\tclock ticks")
   table.insert(consoleOutput, "\t" .. splitsToFirstSolution .. "\tgrid splits")
   table.insert(consoleOutput, "Finished check for others after:")
   table.insert(consoleOutput, "\t" .. stopToken.time  - startToken.time  .. "\tseconds")
   table.insert(consoleOutput, "\t" .. stopToken.clock - startToken.clock .. "\tclock ticks")
   table.insert(consoleOutput, "\t" .. splitsToCheckNoMore .. "\tgrid splits")
   
   print(table.concat(consoleOutput, "\n"))
   
   collectgarbage() -- Force a garbage collection between puzzles
end

print("Done")
