
local utilities = require "core.utilities"

local wrappedProject = project

-- Create a new project with the default setup
function project(projectName)

   -- Make sure we haven't already used this name
   if solution().projects[projectName] then

      error("Duplicate project name: " .. projectName)
   end

   wrappedProject(projectName)

   local project = utilities.getActiveProject()

   local osBin = "../bin/" .. os.get()

   -- The intermediate dir always has subdirs
   -- which are unique to each config and platform
   local  objPath = osBin .. "/intermediate"
   objdir(objPath)

   -- Cache the target path to allow us to
   -- construct prebuild and postbuild events later
   project.objPath = objPath

   -- Change the target paths for each configurations
   for key, configName in pairs(configurations()) do

      for index, platform in ipairs(platforms()) do

         configuration{configName, platform}

         local binPath = path.join(osBin,
            path.join(platform, configName))

         -- Cache the target path to allow us to
         -- construct prebuild and postbuild events later
         project["binPath" .. configName .. platform] = binPath

         targetdir(binPath)
      end
   end

   configuration{"debug"}
   flags        {"Symbols"}

   configuration{"release"}
   flags        {"OptimizeSpeed"}

   if os.is "windows" then

      configuration{"debug"}
      defines      {"_DEBUG"}

      configuration{"release"}
      flags        {"Symbols"}
   end

   configuration{}

   location(utilities.getBuildPath())
end