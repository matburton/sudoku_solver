
-- This extension prevents duplicate defines in projects but
-- comes with a health warning, it prevents the same define
-- being added to mutliple configurations in seperate steps

local array     = require "core.array"
local utilities = require "core.utilities"

local premakeDefines = defines

-- Caches defines already added to ensure
-- that each definition added is unique
function defines(projectDefines)

   local activeProject = utilities.getActiveProject()

   if not activeProject.alreadyDefined then

      activeProject.alreadyDefined = {}
   end

   array.mergeUnique(activeProject.alreadyDefined,
                     projectDefines,
                     premakeDefines)
end