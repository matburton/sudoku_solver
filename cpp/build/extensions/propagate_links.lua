
require "extensions.onlink"

local settings  = require "core.settings"
local utilities = require "core.utilities"
local kind      = require "extensions.kind"

-- Recursively calls itself, traversing down the
-- link tree to fill in the target projects links
local function completeLinks(project)

   utilities.setLinks(project.headerLinks)
   utilities.setLinks(project.sourceOnlyLinks)

   utilities.forEachValidProject(project.headerLinks,     completeLinks)
   utilities.forEachValidProject(project.sourceOnlyLinks, completeLinks)
end

-- Wrap the existing complete all project
-- settings method to propagate links
local wrappedCompleteForActiveProject = settings.completeForActiveProject

settings.completeForActiveProject = function()

   wrappedCompleteForActiveProject()

   local activeProject = utilities.getActiveProject();

   if    kind.isAppProject(activeProject)
      or "SharedLib" == activeProject.kind then

      completeLinks(activeProject)
   end
end