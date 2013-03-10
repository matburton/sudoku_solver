
require "core.submodule"

local array = require "core.array"

local originalWorkingDir = os.getcwd()

-- Load the project file found in the build of the given path and
-- return its path relative to the directory where the action was run
--
function loadProject(projectPath)

   local filePath

   if os.isfile(projectPath .. "/build/project.lua") then

      filePath = projectPath .. "/build/project.lua"
   else

      filePath = projectPath .. "/project.lua"
   end

   dofile(filePath)

   return path.getrelative(originalWorkingDir,
                           path.join(os.getcwd(), filePath))
end

local _ACTION  = _ACTION
local error    = error
local ipairs   = ipairs
local links    = links
local os       = os
local pairs    = pairs
local path     = path
local project  = project
local solution = solution
local table    = table

submodule(...)

-- Returns the project to which
-- settings are currently being applied
function getActiveProject()

   return project()
end

-- Changes the current active project
function setActiveProject(projectName)

   if not solution().projects[projectName] then

      error("No project named " .. projectName)
   end

   project(projectName)
end

-- Add project links to
-- the currently active project
function setLinks(projectNames)

   -- Don't allow a project to depend on itself
   for index, projectName in ipairs(projectNames) do

      if projectName ~= getActiveProject().name then

         links{projectName}
      end
   end
end

-- For each project name that exists in the solution
-- the functor is called with the project as the parameter
function forEachValidProject(projectNames, functor)

   local projects = solution().projects

   for index, projectName in ipairs(projectNames) do

      local project = projects[projectName]

      if project then

         functor(project)
      end
   end
end

-- Removes the projects for which
-- the given functor returns true
function removeProjectsIf(func)

   local projects = solution().projects

   array.removeIf(projects, func)

   for key, project in pairs(projects) do

      if func(project) then

         projects[key] = nil
      end
   end
end

-- Returns the last part of the
-- path for a build directory
function getBuildPath()

   local ideName = _ACTION

   return path.join(os.get(), ideName)
end

-- Returns an array containing the values
-- between the commas in the given string
function splitCommaList(commaList)

   local items = {}

   for value in commaList:gmatch("%s*([^,]+)%s*") do

      table.insert(items, value)
   end

   return items
end

-- Returns an array of all the files in the
-- given project relative to the provided path
--
function getFilesInProject(project, basePath)

   local files = {}

   for key, config in pairs(project.__configs) do

      for index, file in ipairs(config.files) do

         local relativeFilePath =
            path.getrelative(basePath,
                             path.join(project.location, file))

         array.mergeUnique(files, {relativeFilePath}, array.noOp)
      end
   end

   return files
end