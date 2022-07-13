package("drogon")
    set_homepage("https://github.com/an-tao/drogon/")
    set_description("Drogon: A C++14/17 based HTTP web application framework running on Linux/macOS/Unix/Windows")
    set_license("MIT")

    add_urls("https://github.com/drogonframework/drogon.git")

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
        table.insert(configs, "-DBUILD_POSTGRESQL=OFF")
        table.insert(configs, "-DLIBPQ_BATCH_MODE=OFF")
        table.insert(configs, "-DBUILD_MYSQL=" .. (package:config("mysql") and "ON" or "OFF"))
        table.insert(configs, "-DBUILD_SQLITE=OFF")
        table.insert(configs, "-DBUILD_REDIS=" .. (package:config("redis") and "ON" or "OFF"))
        table.insert(configs, "-DBUILD_TESTING=OFF")
        import("package.tools.cmake").install(package, configs)
    end)
package_end()