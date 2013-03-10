
require "core.submodule"

local utilities = require "core.utilities"

local ipairs   = ipairs
local solution = solution

submodule(...)

-- Completes the settings for the active project,
-- called once all projects have been defined
function completeForActiveProject() end

-- Checks each project in turn and adds the user
-- settings from linked in projects to this project
function completeForAllProjects()

   for index, project in ipairs(solution().projects) do

      utilities.setActiveProject(project.name)

      completeForActiveProject()
   end
end