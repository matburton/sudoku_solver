
#-------------------------------------------------------------------------------
def generate(currentGrid):
   """Returns a generator object that finds solutions to a grid. 
      Yeilds a solution and the number of splits performed so far"""

   if not currentGrid.isPossible():
   
      return

   inspectionStack = []
   
   splitsPerformed = 0
   
   while True:
      
      currentGrid.refine()
   
      if currentGrid.isComplete():
      
         yield currentGrid, splitsPerformed
         
      elif currentGrid.isPossible():
         
         gridSplits = currentGrid.split()
        
         splitsPerformed += len(gridSplits)
         
         for grid in gridSplits:
         
            if grid.isComplete():
            
               yield grid, splitsPerformed
               
            elif grid.isPossible():
                   
               inspectionStack.append(grid)
      
      if len(inspectionStack):
      
         currentGrid = inspectionStack.pop()
         
      else: break
