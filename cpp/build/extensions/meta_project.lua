
require "extensions.project"
require "extensions.onlink"

local array     = require "core.array"
local settings  = require "core.settings"
local utilities = require "core.utilities"

-- Use this to create a meta project
function metaProject(projectName)

   project(projectName)

   local project = utilities.getActiveProject()

   project.metaProject = true
end

-- Returns true if the given project
-- name is the name of a meta-project
local function isMetaProject(projectName)

   local projects = solution().projects

   return projects[projectName] and projects[projectName].metaProject
end

-- Delete all links that are meta-projects
-- from all projects in the solution as
-- well as the meta-projects themselves
local function removeMetaProjects()

   local projects = solution().projects

   for index, project in pairs(projects) do

      array.removeIf(project.headerLinks,     isMetaProject)
      array.removeIf(project.sourceOnlyLinks, isMetaProject)
   end

   utilities.removeProjectsIf(function(project)

      return project.metaProject
   end)
end

-- Wrap the existing set links method to prevent
-- projects from trying to link to meta-project libs
local wrappedSetLinks = utilities.setLinks

utilities.setLinks = function(projectNames)

   local namesCopy = {}

   array.mergeInto(namesCopy, projectNames)

   array.removeIf(namesCopy, isMetaProject)

   wrappedSetLinks(namesCopy)
end

-- Wrap the existing complete all settings
-- method to remove meta projects
local wrappedCompleteForAllProjects = settings.completeForAllProjects

settings.completeForAllProjects = function()

   wrappedCompleteForAllProjects()

   removeMetaProjects()
end