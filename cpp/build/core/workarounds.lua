
-- The windows command line doesn't accept more than 8191. For now
-- I just refuse to process command lines greater than that length
--
if os.is "windows" then

   local oldExecute = os.execute

   os.execute = function(command)

      if string.len(command) > 8191 then

         print "Error: Windows command line has a 8191 character limitation"

         return 1
      else

         return oldExecute(command)
      end
   end
end