
#-------------------------------------------------------------------------------
def line(line):
   """Returns a grid with square values 
      set from a line of square values. 
      The line must represent a grid with 
      a sector size of 3 or smaller"""

   from . grid import Grid

   sectorDimension = len(line) ** 0.25
   
   if int(sectorDimension) != sectorDimension:
   
      raise ValueError("Cannot create a grid from a line of %s characters"
                       % len(line))
      
   elif sectorDimension > 3:
   
      raise ValueError(  "Cannot parse a line which would"
                       + " have a sector dimension of %s"
                       % sectorDimension)
      
   sectorDimension = int(sectorDimension)
      
   newGrid = Grid(sectorDimension)
   
   gridDimension = sectorDimension ** 2

   for character, (colIndex, rowIndex) in zip(line,
                 [(colIndex, rowIndex) for rowIndex in range(gridDimension)
                                       for colIndex in range(gridDimension)]):
                                       
      if character != "." and character != "0":
         
         newGrid.setSquareValue(colIndex, rowIndex, int(character))
         
   return newGrid
   
      
