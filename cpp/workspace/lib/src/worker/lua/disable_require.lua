
previous_require = require

require = function(moduleName)

   return package.loaded[moduleName]
end