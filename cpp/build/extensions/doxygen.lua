
local array     = require "core.array"
local utilities = require "core.utilities"

require "extensions.generated_files"

if "doxygen" == _ACTION then

   -- We don't want, and can't include anyway,
   -- generated files in the documentation
   function generatedFiles(fileList) end
end

-- Flags that the active project should
-- not be included in any documentation
function excludeFromDocumentation()

   utilities.getActiveProject().dontDocument = true
end

-- Generates a doxyfile for the projects in
-- the solution in the solutions output dir
local function generateDoxyfile()

   local filePath = solution().location .. "/Doxyfile"

   local doxyFile = io.open(filePath, "w")

   if not doxyFile then

      print("Failed to write-out Doxyfile")

   else

      doxyFile:write("\nPROJECT_NAME = " ..
                     solution().name .. "\n")

      doxyFile:write("\n@INCLUDE = ../../resources/doxygen_template\n")

      local solutionPath = path.getabsolute(solution().location
                                           .. "/../../..")

      doxyFile:write("\nSTRIP_FROM_PATH = " .. solutionPath .. "\n")

      local files = {}

      for index, project in ipairs(solution().projects) do

         if not project.dontDocument then

            local filesInProject = utilities.getFilesInProject(project,
                                                               solution().location)
            array.mergeInto(files, filesInProject)
         end
      end

      doxyFile:write("\nINPUT = " .. table.concat(files, " "))

      doxyFile:close()
   end
end

-- Runs doxygen in the
-- solution output dir
local function processDoxyfile()

   os.rmdir(solution().location .. "/bin")

   if os.execute("doxygen --version") ~= 0 then

      print("Install doxygen to generate the documentation")

   else

      -- We have to change dir to ensure that the
      -- output is created in the correct place
      local oldWorkingDir = os.getcwd()

      os.chdir(solution().location)

      if os.execute("doxygen") ~= 0 then

         print("Doxygen failed to generate the documentation")
      end

      os.chdir(oldWorkingDir)
   end
end

-- Generates a doxyfile and the documentation
-- in the projects output dir
local function generateDocumentation()

   generateDoxyfile()

   processDoxyfile()
end

newaction{trigger     = "doxygen",
          description = "Generate doxygen documentation",
          execute     = generateDocumentation}