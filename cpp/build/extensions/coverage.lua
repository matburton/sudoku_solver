
require "extensions.build_events"
require "extensions.project"

local array     = require "core.array"
local clean     = require "core.clean"
local settings  = require "core.settings"
local utilities = require "core.utilities"
local kind      = require "extensions.kind"

-- Adds a run of the program and generates a coverage
-- report as a post build step of the active project
local function completeReportCoverage()

   local activeProject = utilities.getActiveProject()

   local coverageFor = {}

   for index, projectName in ipairs(activeProject.coverageFor) do

      local project = solution().projects[projectName]

      if not project then

         error("Cannot create coverage report for "
               .. activeProject.name .. ": "
               .. projectName .. " does not exist")
      end

      table.insert(coverageFor, project)
   end

   runPostBuild() -- Run this project post build

   -- Generate a coverage report post debug builds
   local coverage_dir  = "../../../coverage"
   local coverage_tmp  = coverage_dir .. "/coverage.temp"
   local coverage_file = coverage_dir .. "/coverage.info"

   configuration{"debug"}

   -- Delete the previous coverage report
   postbuildcommands{"rm -rf \"" .. coverage_dir .. "\"",
                     "mkdir \""  .. coverage_dir .. "\""}

   for index, project in ipairs(coverageFor) do

      local objPath = path.rebase(project.objPath,
                                  project.basedir,
                                  activeProject.basedir)

      for key, platform in ipairs(platforms()) do

         configuration{"debug", platform}

         local intermediatePath = "../../" .. objPath

         local projectBuildPath = path.join(project.basedir,
                                            utilities.getBuildPath())

         local projectPath = path.getabsolute(project.basedir .. "/..")

         postbuildcommands{

            -- Counters won't be generated for object files
            -- containing code which isn't touched, so we
            -- must generate empty files for such objects
            string.format("touch `find %q -name *.gcno | sed %q`",
                          intermediatePath, [[s/\(.*\.\)gcno/\1gcda/]]),

            -- First we capture the counter data for this project
            string.format("lcov --directory %q --capture " ..
                          "--base-directory %q --output-file %q",
                          intermediatePath, projectBuildPath, coverage_tmp),

            -- Next we remove data for source not from the project
            string.format("lcov --extract %q %q --output-file %q",
                          coverage_tmp, projectPath .. "*", coverage_tmp),

            -- Finally we combine this project's counters
            -- into the aggregated file for all projects
            string.format("lcov --add-tracefile %q --output-file %q",
                          coverage_tmp, coverage_file)
         }
      end
   end

   configuration{"debug"}

   -- Create a HTML report from the gathered data
   postbuildcommands{
      string.format("genhtml --title %q --output-directory %q %q",
                    activeProject.name, coverage_dir, coverage_file)}

   configuration{}
end

local coverageSupported = false

-- Check if we can enable coverage builds
if not os.is "windows" then

   if    os.execute("lcov -v")    ~= 0
      or os.execute("genhtml -v") ~= 0 then

      print("Install lcov and genhtml to enable"
            .. " debug test coverage reports")
   else

      coverageSupported = true
   end
end

if coverageSupported then

   -- Wrap the existing project method
   -- to enable coverage builds
   local wrappedProject = project

   function project(projectName)

      wrappedProject(projectName)

      configuration{"debug"}
      buildoptions {"--coverage"}
      linkoptions  {"--coverage"}

      local activeProject = utilities.getActiveProject()

      local objPath = "../../" .. activeProject.objPath

      prebuildcommands{

         -- Make the folder if it doesn't exist to
         -- prevent the find and delete from failing
         string.format("mkdir --parents %q", objPath),

         string.format("find %q -name *.gcda -delete", objPath)
      }

      configuration{}
   end

   -- Simply notes which projects we want to report
   -- coverage for, they may not be defined yet
   function reportCoverage(projectsToExamine)

      local activeProject = utilities.getActiveProject()

      if not activeProject.coverageFor then

         activeProject.coverageFor = {}
      end

      array.mergeUnique(utilities.getActiveProject().coverageFor,
                        projectsToExamine)
   end

   -- Wrap the existing complete all project settings
   -- method to complete the post build coverage steps
   local wrappedCompleteForActiveProject = settings.completeForActiveProject

   settings.completeForActiveProject = function()

      wrappedCompleteForActiveProject()

      local activeProject = utilities.getActiveProject()

      if     kind.isAppProject(activeProject)
         and activeProject.coverageFor then

         completeReportCoverage()
      end
   end
else

   -- Otherwise projects that use coverage just
   -- run post build without doing anything extra
   reportCoverage = runPostBuild
end

-- Wrap the existing clean method
-- to remove coverage reports
local wrappedClean = clean.everything

clean.everything = function()

   wrappedClean()

   for index, project in ipairs(solution().projects) do

      os.rmdir(project.basedir .. "/../coverage")
   end
end