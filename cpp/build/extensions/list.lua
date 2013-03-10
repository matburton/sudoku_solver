
local function listProjects()

   local projectNames = {}

   for index, project in ipairs(solution().projects) do

      table.insert(projectNames, project.name)
   end

   table.sort(projectNames)

   for index, name in ipairs(projectNames) do

      print("\t" .. name)
   end

   os.rmdir(solution().location)
end

newaction{trigger     = "list",
          description = "List projects",
          execute     = listProjects}