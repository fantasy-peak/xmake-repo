package("luabridge")
    set_homepage("https://github.com/vinniefalco/LuaBridge")
    set_description("About A lightweight, dependency-free library for binding Lua to C++")

    add_urls("https://github.com/vinniefalco/LuaBridge.git")

    -- add_deps("lua", {system = "false"})

    on_install("linux", function (package)
        -- local configs = {}
        -- table.insert(configs, "-DCMAKE_BUILD_TYPE=Release")
        -- table.insert(configs, "-B build")
        -- table.insert(configs, "-DLUABRIDGE_CXX17=1")
        -- import("package.tools.cmake").install(package, configs)
        os.cp("Source/LuaBridge", package:installdir("include"))
    end)

