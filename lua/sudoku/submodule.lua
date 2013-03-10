
-- Used to create a private sub-module which
-- won't pollute the parent module's namespace
function submodule(moduleName) -- We actually want to
                               -- declare this globally
   local moduleEnvironment = {}
   
   package.loaded[moduleName] = moduleEnvironment
   
   setfenv(2, moduleEnvironment)
   
end
