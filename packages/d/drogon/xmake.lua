package("drogon")
    set_homepage("https://github.com/an-tao/drogon/")
    set_description("Drogon: A C++14/17/20 based HTTP web application framework running on Linux/macOS/Unix/Windows")
    set_license("MIT")

    add_urls("https://github.com/drogonframework/drogon.git")

    add_urls("https://github.com/drogonframework/drogon/archive/refs/tags/$(version).tar.gz")
    add_versions("v1.8.4", "6f2f59ead0f0c37b0aac4bc889cbaedf3c2540f3020e892596c72f0a4d887a18")

    add_deps("cmake")
    add_deps("trantor")
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
            package:add("deps", "hiredis")
        end
    end)

    on_install("linux", function (package)
        local configs = {}
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
        import("package.tools.cmake").install(package, configs)
    end)
package_end()
