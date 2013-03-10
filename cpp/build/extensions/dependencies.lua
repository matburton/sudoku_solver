
require "extensions.build_events"
require "extensions.onlink"

local array     = require "core.array"
local utilities = require "core.utilities"

local ipairs   = ipairs
local solution = solution
local table    = table

submodule(...)

-- Given a project adds all names of the projects
-- it directly depends on to build to the given list
local function addProjectDependencies(project, list)

   utilities.forEachValidProject(project.headerLinks, function(prj)

      table.insert(list, prj.name)
   end)

   utilities.forEachValidProject(project.sourceOnlyLinks, function(prj)

      table.insert(list, prj.name)
   end)

   local preBuildNames = {}

   for index, pair in ipairs(project.preBuild) do

      table.insert(preBuildNames, pair.projectName)
   end

   utilities.forEachValidProject(preBuildNames, function(prj)

      table.insert(list, prj.name)
   end)
end

-- Given an list of project names adds the names
-- of the projects on which each project depends
function addDependencies(projectNames)

   utilities.forEachValidProject(projectNames, function(prj)

      addProjectDependencies(prj, projectNames)
   end)
end

-- Given a project adds all names of the projects that
-- directly depend on it to build to the given list
local function addProjectDependents(project, list)

   for index, prj in ipairs(solution().projects) do

      local preBuildNames = {}

      for index, preBuild in ipairs(prj.preBuild) do

         table.insert(preBuildNames, preBuild.projectName)
      end

      if    array.contains(prj.headerLinks,     project.name)
         or array.contains(prj.sourceOnlyLinks, project.name)
         or array.contains(preBuildNames,       project.name) then

         table.insert(list, prj.name)
      end
   end
end

-- Given an list of project names adds the names
-- of the projects that directly depend on each
function addDependents(projectNames)

   utilities.forEachValidProject(projectNames, function(prj)

      addProjectDependents(prj, projectNames)
   end)
end