package("drogon")
    set_homepage("https://github.com/an-tao/drogon/")
    set_description("Drogon: A C++14/17/20 based HTTP web application framework running on Linux/macOS/Unix/Windows")
    set_license("MIT")

    add_urls("https://github.com/drogonframework/drogon.git")

    add_urls("https://github.com/drogonframework/drogon/archive/refs/tags/$(version).tar.gz")
    add_versions("v1.9.8", "62332a4882cc7db1c7cf04391b65c91ddf6fcbb49af129fc37eb0130809e0449")
    add_deps("cmake")

    if is_plat("linux") then
        add_syslinks("pthread", "dl")
    end

    add_deps("trantor cc9cef2822247863b10858190365f106662938c2")
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

