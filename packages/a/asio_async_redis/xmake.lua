package("asio_async_redis")
    set_homepage("https://github.com/fantasy-peak/asio_async_redis")
    set_description("")
    set_license("MIT")
    set_kind("library", {headeronly = true})

    add_urls("https://github.com/fantasy-peak/asio_async_redis.git")

    add_deps("cmake")

    on_install("linux", function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=Release")
        import("package.tools.cmake").install(package, configs, {buildir = os.tmpfile() .. ".dir"})
    end)
package_end()
