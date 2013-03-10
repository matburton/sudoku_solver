
local array        = require "core.array"
local settings     = require "core.settings"
local utilities    = require "core.utilities"
local dependencies = require "extensions.dependencies"

newoption{trigger     = "all",
          value       = "A,B",
          description = "Include only projects in this list," ..
                        " their dependencies and dependents"}

-- Given an array of project names, removes all projects
-- that aren't the named projects or a dependency of
-- any of the named projects from the solution
local function removeUnrelatedProjects(wantedNames)

   local projects = solution().projects

   for name in ipairs(wantedNames) do

      if not projects[name] then

         error(name .. " is not a project name")
      end
   end

   dependencies.addDependents(wantedNames)

   dependencies.addDependencies(wantedNames)

   utilities.removeProjectsIf(function(project)

      return not array.contains(wantedNames, project.name)
   end)
end

-- Wrap the existing complete all settings
-- method to remove unwanted projects
local wrappedCompleteForAllProjects = settings.completeForAllProjects

settings.completeForAllProjects = function()

   wrappedCompleteForAllProjects()

   if _OPTIONS.all then

      removeUnrelatedProjects(
         utilities.splitCommaList(_OPTIONS.all))
   end
end