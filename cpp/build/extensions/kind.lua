
require "core.submodule"

local utilities = require "core.utilities"

local premakeKind = kind

-- An extended version of premakes kind function that
-- makes a note of the kind of project in the project
function kind(projectKind)

   premakeKind(projectKind)

   utilities.getActiveProject().kind = projectKind
end

submodule(...)

-- Returns ture if the given
-- project outputs an executable
function isAppProject(project)

   return project.kind == "ConsoleApp"
       or project.kind == "WindowedApp"
end