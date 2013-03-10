
-- This extension prevents duplicate includes in projects but
-- comes with a health warning, it prevents the same include
-- being added to mutliple configurations in seperate steps

local array     = require "core.array"
local utilities = require "core.utilities"

local premakeIncludeDirs = includedirs

-- Caches includes already added to ensure
-- that each include added is unique
function includedirs(includeDirs)

   local activeProject = utilities.getActiveProject()

   if not activeProject.alreadyIncluded then

      activeProject.alreadyIncluded = {}
   end

   array.mergeUnique(activeProject.alreadyIncluded,
                     includeDirs,
                     premakeIncludeDirs)
end