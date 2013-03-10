
local array        = require "core.array"
local settings     = require "core.settings"
local utilities    = require "core.utilities"
local dependencies = require "extensions.dependencies"

newoption{trigger     = "only",
          value       = "A,B",
          description = "Include only projects in this" ..
                        " list and their dependencies"}

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

   if _OPTIONS.only then

      removeUnrelatedProjects(
         utilities.splitCommaList(_OPTIONS.only))
   end
end