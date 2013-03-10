
local array     = require "core.array"
local settings  = require "core.settings"
local utilities = require "core.utilities"

-- Wrap the existing project
-- method to add empty link tables
local wrappedProject = project

function project(projectName)

   wrappedProject(projectName)

   local activeProject = utilities.getActiveProject()

   activeProject.headerLinks     = {}
   activeProject.sourceOnlyLinks = {}
end

-- Used to specify that headers and source in
-- the current project depend on these projects
function headerLinks(headerLinks)

   array.mergeInto(utilities.getActiveProject().headerLinks,
                   headerLinks)
end

-- Used to specify that source files in the
-- current project depend on these projects
function links(sourceOnlyLinks)

   array.mergeInto(utilities.getActiveProject().sourceOnlyLinks,
                   sourceOnlyLinks)
end

-- Sets the functor used to complete settings
-- for projects that link to the current project
function onLink(func)

   local activeProject = utilities.getActiveProject()

   local oldOnLink = activeProject.onLink

   if oldOnLink then

      activeProject.onLink = function()

         oldOnLink()

         func()
      end

   else

      activeProject.onLink = func
   end
end

-- Calls the given projects onLink
-- function with the necessary environment
local function callOnLinkFor(project)

   -- Wrap the includedirs function
   -- so that it rebases the paths
   local oldIncludeDirsFunc = includedirs

   includedirs = function(includeDirs)

      -- We have to change dir to ensure
      -- that the includes get added correctly
      local oldWorkingDir = os.getcwd()

      local activeProject = utilities.getActiveProject()

      -- We must rebase the paths to make them relative to
      -- the target project instead of the current project
      for index, include in ipairs(includeDirs) do

         os.chdir(activeProject.basedir)

         oldIncludeDirsFunc{path.rebase(include,
                                        project.basedir,
                                        activeProject.basedir)}
      end

      os.chdir(oldWorkingDir)
   end

   if project.onLink then
      project.onLink()
   end

   -- Restore the old include dirs
   includedirs = oldIncludeDirsFunc
end

-- Same as completeSettings but does not
-- follow or call onLink for source links
local function completeHeaderOnly(project)

   callOnLinkFor(project)

   utilities.forEachValidProject(project.headerLinks,
                                 completeHeaderOnly)
end

-- Recursively calls itself, traversing down the
-- link tree to fill in the target projects settings
local function completeSettings(project)

   callOnLinkFor(project)

   utilities.forEachValidProject(project.sourceOnlyLinks,
                                 completeHeaderOnly)

   utilities.forEachValidProject(project.headerLinks,
                                 completeSettings)
end

-- Wrap the existing complete all project settings
-- method to call execute the onLink functions
local wrappedCompleteForActiveProject = settings.completeForActiveProject

settings.completeForActiveProject = function()

   wrappedCompleteForActiveProject()

   completeSettings(utilities.getActiveProject())
end