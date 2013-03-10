
require "extensions.generated_files"

local array     = require "core.array"
local utilities = require "core.utilities"

if "complexity" == _ACTION then

   -- We don't want, and can't include anyway,
   -- generated files in the documentation
   function generatedFiles(fileList) end
end

local function reportCodeComplexity()

   if os.execute("pmccabe -V") ~= 0 then

      print("Install pmccabe to report code complexity")

   else

      local files = {}

      for index, project in ipairs(solution().projects) do

         if not project.dontDocument then

            local filesInProject = utilities.getFilesInProject(project,
                                                               os.getcwd())
            array.mergeInto(files, filesInProject)
         end
      end

      local runString = "pmccabe -v"

      for key, filePath in pairs(files) do

         runString = string.format("%s %q", runString, filePath)

      end

      if os.execute(runString) ~= 0 then

         print("Failed to report code complexity")

      end

   end

   os.rmdir(solution().location)

end

newaction{trigger     = "complexity",
          description = "Code complexity report",
          execute     = reportCodeComplexity}