
-- Library and tool projects aren't directly
-- maintained in this solution and hence
-- should not be included in the documentation
local wrappedProject = project

function project(projectName)

   wrappedProject(projectName)

   excludeFromDocumentation()

   dontMutateFilesInProject()

   -- We also don't care about the warning generated as a result
   -- of Microsoft trying to deprecate methods in the standard
   if os.is "windows" then

      defines{"_CRT_SECURE_NO_DEPRECATE"}
   end
end

loadProject "../libraries"
loadProject "../tools"

-- Allow these projects to be
-- included in the documentation
project = wrappedProject

loadProject "../workspace"