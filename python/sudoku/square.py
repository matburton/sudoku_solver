
class Square:
   """Encapsulates the remaining possible 
      values of a square in a sudoku"""
  
   #---------------------------------------------------------
   def __init__(self, param):
      """If param is another square this creates 
         a copy, otherwise creates a new square 
         with 1 to parameter as possible values"""
      
      if type(param) is type(self):

         self._possibilities = param._possibilities.copy()
      
      else:
      
         if param < 1:
         
            raise ValueError(  "Cannot create a square with"
                             + " a maximum possibility of %s"
                             % param)
         
         self._possibilities = set(range(1, param + 1))
   
   #---------------------------------------------------------
   def removePossibility(self, possibility):
      """Removes a possible value from the square. 
         Returns True if the possibility existed"""
      
      if self.hasPossibility(possibility):
      
         self._possibilities.remove(possibility)
         
         return True
         
      else:
      
         return False
      
   #---------------------------------------------------------
   def isPossible(self):
      """Returns True if this square 
         has any possible values"""
      
      return bool(len(self._possibilities))
      
   #---------------------------------------------------------
   def getValue(self):
      """Returns value of the square if it has only a 
         single possibility, otherwise returns None"""
      
      if len(self._possibilities) is 1:
      
         return self._possibilities.copy().pop()
         
      else:
      
         return None
      
   #---------------------------------------------------------
   def setValue(self, value):
      """Sets this square to only contain 
         the given value as a possibility"""
      
      self._possibilities = set([value])
      
   #---------------------------------------------------------
   def getPossibilities(self):
      """Returns the possible values for this square"""
      
      return sorted(self._possibilities)
      
   #---------------------------------------------------------
   def hasPossibility(self, value):
      """Returns true if this square contains the 
         given value as on of its possible values"""
      
      return value in self._possibilities
