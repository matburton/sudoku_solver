
class Grid:
   """Encapsulates a grid of squares, each containing 
      possible values, and methods to solve the sudoku"""
   
   #----------------------------------------------------------------------------
   def __init__(self, param):
      """If param is another grid this creates a copy, otherwise 
         creates a new grid with the given sector dimension 
         and with all squares containing all possible values"""
      
      from . square import Square
      
      if type(param) is type(self):
      
         self._sectorDimension = param._sectorDimension
         
         self._gridDimension = param._gridDimension
         
         self._rows = [[Square(sqr) for sqr in row]
                                    for row in param._rows]
      else:
      
         if param < 1:
         
            raise ValueError(  "Cannot create a grid with"
                             + " a sector dimension of %s"
                             % param)
                             
         self._sectorDimension = param
         
         self._gridDimension = param ** 2
         
         self._rows = [[Square(self._gridDimension)
                       for rowIndex in range(self._gridDimension)]
                       for colIndex in range(self._gridDimension)]
         
   #----------------------------------------------------------------------------
   def setSquareValue(self, colIndex, rowIndex, value):
      """Sets the square in the given location to contain 
         the given value as its only possibility"""
     
      if not (    0 <= colIndex < self._gridDimension
              and 0 <= rowIndex < self._gridDimension):
          
          raise ValueError("Cannot index a grid of dimension %s with (%s, %s)"
                           % (self._gridDimension, colIndex, rowIndex))
           
      self._rows[rowIndex][colIndex].setValue(value)
      
      self._removeRelatedPossibilities(colIndex, rowIndex, value)
      
   #----------------------------------------------------------------------------
   def isPossible(self):
      """Returns True if every square still 
         has at least one possible value"""
     
      return all([square.isPossible() for row    in self._rows
                                      for square in row])
      
   #----------------------------------------------------------------------------
   def isComplete(self):
      """Returns True if every square has only 
         a single value, when a grid is complete 
         it has to be a valid sudoku"""
      
      return all([square.getValue() for row    in self._rows
                                    for square in row])
      
   #----------------------------------------------------------------------------
   def refine(self):
      """Applies further rules to the 
         grid to deduce squares values"""
      
      targetIndexes = None
      
      colIndex, rowIndex = 0, 0
      
      while (colIndex, rowIndex) != targetIndexes:
      
         deducedValue = self._deduceSquare(colIndex, rowIndex)
         
         if deducedValue:
         
            self.setSquareValue(colIndex, rowIndex, deducedValue)
            
            if not self.isPossible():
            
               break
            
         if not targetIndexes or deducedValue:
         
            targetIndexes = colIndex, rowIndex
            
         colIndex += 1
         
         if colIndex >= self._gridDimension:
         
            colIndex = 0
            
            rowIndex += 1
            
            if rowIndex >= self._gridDimension:
            
               rowIndex = 0
               
   #----------------------------------------------------------------------------
   def _deduceSquare(self, colIndex, rowIndex):
      """Tries to apply rules to this square to 
         deduce its value, returns the deduced value 
         or None if no deduction could be made"""
      
      square = self._rows[rowIndex][colIndex]
      
      if not square.isPossible() or square.getValue():
      
         return None
         
      for possibility in square.getPossibilities():
      
         if (   self._mustBeValueByRow   (square,   rowIndex, possibility)
             or self._mustBeValueByCol   (colIndex, rowIndex, possibility)
             or self._mustBeValueBySector(colIndex, rowIndex, possibility)):
         
            return possibility
         
      return None
      
   #----------------------------------------------------------------------------
   def _mustBeValueByRow(self, targetSqaure, rowIndex, possibility):
      """Returns true if the given possibility 
         must be the value for the given square"""
      
      return not any([square.hasPossibility(possibility)
                      for square in self._rows[rowIndex]
                       if square is not targetSqaure])
                      
   #----------------------------------------------------------------------------
   def _mustBeValueByCol(self, colIndex, rowIndex, possibility):
      """Returns true if the given possibility 
         must be the value for the given square"""
      
      return not any([self._rows[index][colIndex].hasPossibility(possibility)
                      for index in range(self._gridDimension)
                       if index is not rowIndex])
                       
   #----------------------------------------------------------------------------
   def _mustBeValueBySector(self, colIndex, rowIndex, possibility):
      """Returns true if the given possibility 
         must be the value for the given square"""
      
      return not any([self._rows[iterRows][iterCols].hasPossibility(possibility)
                      for (iterCols, iterRows) in
                      self._getSquaresInSector(colIndex, rowIndex)])
   
   #----------------------------------------------------------------------------
   def split(self):
      """Chooses a square that has two or more possibilities
         and returns a list containing new versions of this
         grid each with the chosen square containing one of
         those possibilities"""

      def countPossibilities(indexes):
   
         colIndex, rowIndex = indexes
   
         return len(self._rows[rowIndex][colIndex].getPossibilities())
      
      indexes = [(colIndex, rowIndex)
                 for rowIndex in range(self._gridDimension)
                 for colIndex in range(self._gridDimension)
                  if countPossibilities((colIndex, rowIndex)) > 1]   
                  
      if len(indexes) is 0:
      
         raise RuntimeError(  "Could not split grid as there "
                            + "were no viable squares to split")

      colIndex, rowIndex = min(indexes, key = countPossibilities)
      
      gridCopies = [Grid(self) for count in
                    range(countPossibilities((colIndex, rowIndex)))]

      square = self._rows[rowIndex][colIndex]
      
      for index, possibility in enumerate(square.getPossibilities()):
      
         gridCopies[index].setSquareValue(colIndex, rowIndex, possibility)
      
      return gridCopies
      
   #----------------------------------------------------------------------------
   def getGridString(self):
      """Returns a string that displays the grid's 
         state in a human-digestible 2D format"""
      
      maxValueLength = len(str(self._sectorDimension ** 2))
      
      sectorDivider = "-" * (maxValueLength + 2) * self._sectorDimension
      
      dividerLine = "+".join([sectorDivider] * self._sectorDimension)
     
      gridValues = [[str(square.getValue() or ".").center(maxValueLength + 2)
                    for square in row]  for row in self._rows]
      
      dividerIndexes = range(self._gridDimension - self._sectorDimension,
                             0, -self._sectorDimension)
      
      for row, index in [(row, index) for row   in gridValues
                                      for index in dividerIndexes]:
         row.insert(index, "|")
      
      rowValues = ["".join(row) for row in gridValues]
      
      for index in dividerIndexes:
      
         rowValues.insert(index, dividerLine)
      
      return "\n".join(rowValues)   
      
   #----------------------------------------------------------------------------
   def getStateLine(self):
      """Returns a string where each character represents a square value. 
         Squares a listed left to right, top to bottom and any squares 
         which don't have a value are shown represented as '.'"""
      
      if self._sectorDimension > 3:
      
         raise RuntimeError(  "Cannot create a state line for"
                            + " a grid with a dimension of %s"
                            % self._sectorDimension)
                            
      gridValues = [square.getValue() or "." for row    in self._rows
                                             for square in row]

      return "".join([str(value) for value in gridValues])
      
   #----------------------------------------------------------------------------
   def _removeRelatedPossibilities(self, colIndex, rowIndex, possibility):
      """Removes the given possibility from related 
         squares but not from the given square itself"""
         
      # Remove the possibility from squares in the row
      column = self._rows[rowIndex]
      
      for colIndexInRow in [index for index in range(self._gridDimension)
                                   if index is not colIndex]:
         
         self._removePossibility(colIndexInRow, rowIndex, possibility)
                
      # Remove the possibility from squares in the column         
      for rowIndexInCol in [index for index in range(self._gridDimension)
                                   if index is not rowIndex]:
             
         self._removePossibility(colIndex, rowIndexInCol, possibility)

      sectorIndexes = self._getSquaresInSector(colIndex, rowIndex)

      # Remove the possibility from squares in the sector
      for sectorColIndex, sectorRowIndex in sectorIndexes:
       
         self._removePossibility(sectorColIndex, sectorRowIndex, possibility)
      
   #----------------------------------------------------------------------------
   def _removePossibility(self, colIndex, rowIndex, possibility):
      """Removes a possibility from a square, if only 
         a single value remains for the square then 
         all related squares are also updated"""
         
      square = self._rows[rowIndex][colIndex]
      
      if square.removePossibility(possibility):
     
         value = square.getValue()
         
         if value:
         
            self._removeRelatedPossibilities(colIndex, rowIndex, value)
                                             
   #----------------------------------------------------------------------------
   def _getSquaresInSector(self, colIndex, rowIndex):
      """Returns a list of tuples in the form (colIndex, rowIndex), 
         of all the squares in the same sector as the given 
         square but excluding the given square itself"""
    
      sectorRowIndex = int(rowIndex / self._sectorDimension)
      sectorColIndex = int(colIndex / self._sectorDimension)

      rowIndexes = list(range(self._sectorDimension *  sectorRowIndex,
                              self._sectorDimension * (sectorRowIndex + 1)))
                         
      colIndexes = list(range(self._sectorDimension *  sectorColIndex,
                              self._sectorDimension * (sectorColIndex + 1)))
                                     
      return [(iterColIndex, iterRowIndex) for iterRowIndex in rowIndexes
                                           for iterColIndex in colIndexes
              if (iterColIndex, iterRowIndex) != (colIndex, rowIndex)]
