
require "core.workarounds"

require "extensions.all"
require "extensions.build_events"
require "extensions.complexity"
require "extensions.copy_shared_libs"
require "extensions.dependents"
require "extensions.doxygen"
require "extensions.generated_files"
require "extensions.graph"
require "extensions.list"
require "extensions.meta_project"
require "extensions.onlink"
require "extensions.only"
require "extensions.project"
require "extensions.propagate_links"
require "extensions.strip"
require "extensions.unique_defines"
require "extensions.unique_includes"

local clean     = require "core.clean"
local settings  = require "core.settings"
local utilities = require "core.utilities"

if _ACTION then

   local sol = solution "sudoku_solver"

   configurations{"debug", "release"}

   platforms{"x32", "x64"}

   location(utilities.getBuildPath())

   dofile "projects.lua"

   settings.completeForAllProjects()

   if _ACTION == "clean" then

      clean.everything()
   end
end