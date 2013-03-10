
-- Generated files are assumed
-- to be in the bin directory
function generatedFiles(fileList)

   for index, file in ipairs(fileList) do

      files{"../bin/" .. file}
   end
end