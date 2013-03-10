
metaProject "boost"

onLink(function()

   includedirs{"../src"}
   defines    {"BOOST_ALL_NO_LIB"}
end)

-- Load all the boost projects
loadProject "test"