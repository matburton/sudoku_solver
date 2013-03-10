
local array        = require "core.array"
local settings     = require "core.settings"
local utilities    = require "core.utilities"
local dependencies = require "extensions.dependencies"

newoption{trigger     = "dependents",
          value       = "A,B",
          description = "Indicates projects that "
                        .. "depend on those listed"}

-- Given an array of project names, removes all projects
-- that aren't the named projects or aren't dependent
-- on one of the named projects from the solution
local function removeUnrelatedProjects(wantedNames)

   local projects = solution().projects

   for index, name in ipairs(wantedNames) do

      if not projects[name] then

         error(name .. " is not a project name")
      end
   end

   dependencies.addDependents(wantedNames)

   utilities.removeProjectsIf(function(project)

      return not array.contains(wantedNames, project.name)
   end)

   for index, project in pairs(projects) do

      array.removeIf(project.headerLinks, function(name)

         return not array.contains(wantedNames, name)
      end)

      array.removeIf(project.sourceOnlyLinks, function(name)

         return not array.contains(wantedNames, name)
      end)

      array.removeIf(project.preBuild, function(pre)

         return not array.contains(wantedNames, pre.projectName)
      end)
   end
end

-- Wrap the existing complete all settings
-- method to remove unwanted projects
local wrappedCompleteForAllProjects = settings.completeForAllProjects

settings.completeForAllProjects = function()

   wrappedCompleteForAllProjects()

   if _OPTIONS.dependents then

      if     _ACTION ~= "graph"
         and _ACTION ~= "list"
         and _ACTION ~= "doxygen"
         and _ACTION ~= "complexity" then

         error("The dependents option can only be used in conjunction" ..
               " with graph, list, doxygen and complexity actions")
      end

      removeUnrelatedProjects(
         utilities.splitCommaList(_OPTIONS.dependents))
   end
end