
require "sudoku.parsers"
require "sudoku.solvers"
require "sudoku.printers"

local print = print

local time  = os.time
local clock = os.clock

local resume = coroutine.resume

sudoku = sudoku or {}

_ENV = sudoku

-- Shortcut for solving a sudoku
-- line, also prints the time taken
function solveLineSingle(line)

   print("Starting Timer...")
   local startToken = { time  = time(),
                        clock = clock() }

   print("Parsing Line and Setting-up Grid...")
   local grid = sudoku.parseLine(line)
   
   print("Searching for a Single Solution...")
   local solution, splits = sudoku.findSingleSolution(grid)
   
   local stopToken = { time  = time(),
                       clock = clock() }
   print("Timer stopped - Found a Solution")
   print("Finished in " .. stopToken.time  - startToken.time .. " seconds")
   print("Finished in " .. stopToken.clock - startToken.clock .. " ticks")
   print("Number of grid splits performed: " .. splits)
   
   if solution then
      print(sudoku.getGridString(solution))
   else
      print("No Solution Found")
   end

end

-- Shortcut consumer for finding all the solutions for a grid but 
-- prints the time taken and with each solution as they're found
function solveLineAll(line)
   
   print("Starting Timer...")
   local startToken = { time  = time(),
                        clock = clock() }

   print("Parsing Line and Setting-up Grid...")
   local grid = sudoku.parseLine(line)
   
   local coroutine = sudoku.produceSolutions(grid)
     
   local solutionCount = 0
   
   local splits = 0
   
   print("Searching for All Solutions...")
   repeat
   
      local dummy, solution
      
      dummy, solution, splits = resume(coroutine)
      
      if solution then
         solutionCount = solutionCount + 1
         print("Found a solution, " .. solutionCount .. " found so far")
         print("Found after " .. time()  - startToken.time .. " seconds")
         print("Found after " .. clock() - startToken.clock .. " ticks")
         print("Number of grid splits performed so far: " .. splits)
         print(sudoku.getGridString(solution))
      end
      
   until not solution
   
   local stopToken = { time  = time(),
                       clock = clock() }   
   print("Timer stopped - No More Solutions")
   print("Finished in " .. stopToken.time  - startToken.time .. " seconds")
   print("Finished in " .. stopToken.clock - startToken.clock .. " ticks")
   print("Found " .. solutionCount .. " solutions")
   print("Number of grid splits performed: " .. splits)
end
