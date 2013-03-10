
require "extensions.onlink"

local array     = require "core.array"
local settings  = require "core.settings"
local utilities = require "core.utilities"
local kind      = require "extensions.kind"

-- Recursively calls itself, traversing down the
-- link tree to fill in the target projects links
--
local function findSharedLibs(configName, platform, sharedLibPaths, project)

   if project.kind == "SharedLib" then

      local binPath = project["binPath" .. configName .. platform]

      local activeProject = utilities.getActiveProject();

      binPath = path.rebase(binPath,
                            project.basedir,
                            activeProject.basedir)

      local libExtension = ".so"

      if os.is "windows" then libExtension = ".dll" end

      local libPath = path.join(binPath, project.name .. libExtension)

      array.mergeUnique(sharedLibPaths, {libPath})
   end

   local findSharedLibsAndMerge = function(prj)

      findSharedLibs(configName, platform, sharedLibPaths, prj)
   end

   utilities.forEachValidProject(project.headerLinks,
                                 findSharedLibsAndMerge)

   utilities.forEachValidProject(project.sourceOnlyLinks,
                                 findSharedLibsAndMerge)
end

-- Wrap the existing complete all project
-- settings method to add build events
--
local wrappedCompleteForActiveProject = settings.completeForActiveProject

settings.completeForActiveProject = function()

   wrappedCompleteForActiveProject()

   local activeProject = utilities.getActiveProject();

   if kind.isAppProject(activeProject) then

      -- Add the build event with the correct path
      -- for all configurations and platforms
      --
      for key, configName in pairs(configurations()) do

         for index, platform in ipairs(platforms()) do

            configuration{configName, platform}

            local sharedLibPaths = {}

            findSharedLibs(configName, platform, sharedLibPaths, activeProject)

            for index, libPath in ipairs(sharedLibPaths) do

               local command = "cp"

               if os.is "windows" then command = "copy" end

               local activePrjBinPath = activeProject["binPath"
                                                      .. configName
                                                      .. platform]

               libPath          = path.translate("../../" .. libPath)
               activePrjBinPath = path.translate("../../" .. activePrjBinPath)

               postbuildcommands{string.format("%s %q %q",
                                               command,
                                               libPath,
                                               activePrjBinPath)}
            end
         end
      end

      configuration{}
   end
end