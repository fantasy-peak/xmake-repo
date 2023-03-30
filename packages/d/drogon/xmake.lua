package("drogon")
    set_homepage("https://github.com/an-tao/drogon/")
    set_description("Drogon: A C++14/17/20 based HTTP web application framework running on Linux/macOS/Unix/Windows")
    set_license("MIT")

    add_urls("https://github.com/an-tao/drogon/archive/refs/tags/$(version).tar.gz",
             "https://github.com/an-tao/drogon.git")
    add_versions("v1.9.5", "ec17882835abeb0672db29cb36ab0c5523f144d5d8ff177861b8f5865803eaae")
    add_versions("v1.9.4", "b23d9d01d36fb1221298fcdbedcf7fd3e1b8b8821bf6fb8ed073c8b0c290d11d")
    add_urls("https://github.com/drogonframework/drogon.git")

    add_deps("cmake")

    if is_plat("linux") then
        add_syslinks("pthread", "dl")
    end

    add_deps("trantor bd3e8d8a720e827c2c4c23f229bb5d2078f0b96c")
    add_deps("jsoncpp", {system=false})
    add_deps("zlib", {system=false})
    add_deps("brotli", {system=false})
    add_deps("libuuid", {system=false})

    add_configs("mysql", {description = "Enable mysql support.", default = false, type = "boolean"})
    add_configs("redis", {description = "Enable redis support.", default = false, type = "boolean"})

    on_load(function (package)
        if package:config("mysql") then
            package:add("deps", "libmysqlclient")
        end
        if package:config("redis") then
            package:add("deps", "hiredis", {system=false})
        end
        
        if not table.contains(package:get("deps"), "mysql") then
            package:add("deps", "zlib")
        end
    end)

    on_install("macosx", "linux", function (package)
        io.replace("cmake/templates/config.h.in", "\"@COMPILATION_FLAGS@@DROGON_CXX_STANDARD@\"", "R\"(@COMPILATION_FLAGS@@DROGON_CXX_STANDARD@)\"", {plain = true})
        local configs = {"-DBUILD_EXAMPLES=OFF"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_POSTGRESQL=OFF")
        table.insert(configs, "-DLIBPQ_BATCH_MODE=OFF")
        table.insert(configs, "-DBUILD_MYSQL=" .. (package:config("mysql") and "ON" or "OFF"))
        table.insert(configs, "-DBUILD_SQLITE=OFF")
        table.insert(configs, "-DBUILD_REDIS=" .. (package:config("redis") and "ON" or "OFF"))
        table.insert(configs, "-DBUILD_TESTING=OFF")
        table.insert(configs, "-DBUILD_YAML_CONFIG=OFF")
        table.insert(configs, "-DCMAKE_CROSSCOMPILING=OFF")
        table.insert(configs, "-DUSE_SUBMODULE=OFF")
        table.insert(configs, "-DCMAKE_CXX_STANDARD=20")
        import("package.tools.cmake").install(package, configs)
    end)
package_end()

