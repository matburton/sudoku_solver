
require "extensions.generated_files"

local array     = require "core.array"
local utilities = require "core.utilities"

local table = table

-- Flags that the active project should never
-- allow its files to be changed in any way
--
function dontMutateFilesInProject()

   utilities.getActiveProject().dontMutateFiles = true
end

-- Cache project files that are loaded
-- so that we can strip them as well
--
local loadedProjectFiles = {}

local oldLoadProject = loadProject

function loadProject(projectPath)

   local loadedFilePath = oldLoadProject(projectPath)

   table.insert(loadedProjectFiles, loadedFilePath)
end

if "strip" == _ACTION then

   -- We can't strip generated files
   --
   function generatedFiles(fileList) end
end

local function stripFiles()

   if os.execute("stripper_console") ~= 0 then

      print("Install stripper_console to strip files")

   else

      local files = {}

      for index, project in ipairs(solution().projects) do

         if not project.dontMutateFiles then

            local filesInProject = utilities.getFilesInProject(project,
                                                               os.getcwd())
            array.mergeInto(files, filesInProject)
         end
      end

      array.mergeInto(files, loadedProjectFiles)

      local runString = "stripper_console"

      for key, filePath in pairs(files) do

         runString = string.format("%s %q", runString, filePath)

      end

      if os.execute(runString) ~= 0 then

         print("Failed to strip files")

      end
   end

   os.rmdir(solution().location)

end

newaction{trigger     = "strip",
          description = "Remove unnecessary parts of source files",
          execute     = stripFiles}