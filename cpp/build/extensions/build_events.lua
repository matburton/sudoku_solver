
require "extensions.project"

local settings  = require "core.settings"
local utilities = require "core.utilities"
local kind      = require "extensions.kind"

-- Wrap the existing project method
-- to add an empty prebuild list
local wrappedProject = project

function project(projectName)

   wrappedProject(projectName)

   local activeProject = utilities.getActiveProject()

   activeProject.preBuild = {}
end

-- Used to specify that the named project should
-- be built and it's output run with the given
-- arguments before the current project is built
-- arguments may be a function to be evaulated
-- once all projects have been defined
function preBuild(projectName, arguments)

   local preBuild = {}
   preBuild.projectName = projectName
   preBuild.arguments   = arguments

   local activeProject = utilities.getActiveProject()

   table.insert(activeProject.preBuild, preBuild)
end

-- Marks that the given project should be run in response to a
-- stage in the current projects build step defined by the functor
local function addProjectRun(projectName, functor, arguments)

   local activeProject = utilities.getActiveProject()

   -- The project name should exist in the solution
   local projectToRun = solution().projects[projectName]

   if not projectToRun then

      error("Bad build event for " .. activeProject.name
            .. ": " .. projectName .. " does not exist")

   elseif kind.isAppProject(projectToRun) then

      utilities.setLinks{projectName} -- Add a build dependancy

      -- Add the build event with the correct path
      -- for all configurations and platforms
      for key, configName in pairs(configurations()) do

         for index, platform in ipairs(platforms()) do

            configuration{configName, platform}

            local binPath = projectToRun["binPath"
                                         .. configName
                                         .. platform]

            binPath = path.rebase(binPath,
                                  projectToRun.basedir,
                                  activeProject.basedir)

            local runPath = "\"../../" .. binPath .. "/./"
                            .. projectToRun.name .. "\""

            if arguments then

               -- Evaluate the argument if we
               -- have been given a function
               if "function" == type(arguments) then

                  arguments = arguments()
               end

               runPath = runPath .. " " .. arguments
            end

            functor{runPath}
         end
      end

      configuration{}
   end
end

-- Sets the current project's output to
-- be run after the project is built
function runPostBuild()

   addProjectRun(utilities.getActiveProject().name,
                 postbuildcommands)
end

-- Wrap the existing complete all project
-- settings method to add build events
local wrappedCompleteForActiveProject = settings.completeForActiveProject

settings.completeForActiveProject = function()

   wrappedCompleteForActiveProject()

   for key, preBuild in
       ipairs(utilities.getActiveProject().preBuild) do

      addProjectRun(preBuild.projectName,
                    prebuildcommands,
                    preBuild.arguments)
   end
end