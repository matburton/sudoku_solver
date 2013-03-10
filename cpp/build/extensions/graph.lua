
require "extensions.build_events"
require "extensions.onlink"

-- Turn the build graph file into an
-- image if graphviz is available
local function processGraphFile(filePath)

   if os.execute("dot -V") ~= 0 then

      print("Install graphviz to generate graphs")

   else

      for index, format in ipairs({"svg", "png"}) do

         if os.execute(string.format("dot -T%s -o%q.%s %q.dot",
                                     format, filePath,
                                     format, filePath)) ~= 0 then

            error("Failed to generate graph image")
         end
      end
   end
end

local spacer = "   "

-- Outputs all project names for every
-- project to the graph file, the func gets
-- the project names from each project
local function writeProjectNames(graphFile, func)

   for index, project in ipairs(solution().projects) do

      for dummy, projectName in ipairs(func(project)) do

         graphFile:write(spacer .. project.name ..
                         " -> " .. projectName .. "\n")
      end
   end
end

-- Inspect all the projects in the
-- solution and generate a build graph
local function generateBuildGraph()

   local filePath = solution().location ..
                    "/" .. solution().name

   local graphFile = io.open(filePath .. ".dot", "w")

   if not graphFile then

      print("Failed to write-out build graph")

   else

      local graphLabel = "\\nHeader links shown with green lines" ..
                         "\\nSource only links shown with black lines" ..
                         "\\nPre-build dependencies shown with orange lines"

      graphFile:write("digraph\n{\n")

      graphFile:write(spacer .. "label=\"" .. graphLabel .. "\"\n\n")

      graphFile:write(spacer .. "node [shape=box]\n\n")

      -- Write out all project names to include
      -- projects that don't have any dependancies
      for index, project in ipairs(solution().projects) do

         graphFile:write(spacer .. project.name .. "\n")
      end

      graphFile:write("\n" .. spacer .. "edge [color=darkgreen]\n\n")

      writeProjectNames(graphFile, function(project)
         return project.headerLinks
      end)

      graphFile:write("\n" .. spacer .. "edge [color=black]\n\n")

      writeProjectNames(graphFile, function(project)
         return project.sourceOnlyLinks
      end)

      graphFile:write("\n" .. spacer .. "edge [color=orange]\n\n")

      writeProjectNames(graphFile, function(project)

         local projectNames = {}

         for index, preBuild in ipairs(project.preBuild) do

            table.insert(projectNames, preBuild.projectName)
         end

         return projectNames
      end)

      graphFile:write("}")

      graphFile:close()

      processGraphFile(filePath)
   end
end

newaction{trigger     = "graph",
          description = "Graphviz dependency graph",
          execute     = generateBuildGraph}