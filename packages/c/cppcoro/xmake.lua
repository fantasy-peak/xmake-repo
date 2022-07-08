package("cppcoro")
    set_homepage("https://github.com/fantasy-peak/cppcoro.git")
    set_description("")
    set_license("")

    add_urls("https://github.com/fantasy-peak/cppcoro.git")

    on_install("linux", function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=Release")
        import("package.tools.cmake").install(package, configs)
    end)
package_end()