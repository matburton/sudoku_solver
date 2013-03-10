
require "core.submodule"

local ipairs   = ipairs
local os       = os
local path     = path
local solution = solution

submodule(...)

-- Removes all files generated
-- by premake and build files
function everything()

   os.rmdir(os.get())

   for index, project in ipairs(solution().projects) do

      os.rmdir(path.join(project.basedir, os.get()))

      os.rmdir(project.basedir .. "/../bin")
   end
end