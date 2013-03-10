
# Manually edit the search paths since the
# sudoku package won't be in them otherwise
import sys

sys.path.append("../../python")

try:

   import psyco
   
   psyco.full()

except ImportError: pass

import time

import sudoku.parse
import sudoku.solutions

puzzleLines = open("puzzles.txt").readlines()

outputFile = open("python_results.csv", "w")

puzzleLines = [line.rstrip() for line in puzzleLines]

for index, puzzleLine in enumerate(puzzleLines):

   print("Solving puzzle number %s" % (index + 1))
   
   startTime = time.time()

   puzzle = sudoku.parse.line(puzzleLine)
   
   solutionGenerator = sudoku.solutions.generate(puzzle)
   
   try:
      
      if sys.version_info[0] < 3:
      
         solution, splits = solutionGenerator.next()
         
      else:
      
         solution, splits = solutionGenerator.__next__()
      
      timeToSolve = time.time() - startTime
      
   except StopIteration:
   
      raise RuntimeError("Didn't find a solution to %s"
                         % puzzleLine)

   print(solution.getGridString())
      
   print("Found after %s grid splits and %s seconds\n"
         % (splits, timeToSolve))
         
   outputFile.write(",".join([puzzleLine, solution.getStateLine(),
                              str(timeToSolve), str(splits)]) + "\n")
