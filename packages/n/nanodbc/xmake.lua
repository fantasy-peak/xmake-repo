package("nanodbc")
    set_homepage("https://github.com/nanodbc/nanodbc.git")
    set_description("")

    add_urls("https://github.com/nanodbc/nanodbc.git")
    add_deps("cmake")
    add_deps("unixodbc", {system = false})

    on_install("linux", "windows", function (package)
        local configs = {}
        table.insert(configs, "-DNANODBC_ODBC_VERSION=SQL_OV_ODBC3")
        import("package.tools.cmake").install(package, configs)
    end)
package_end()
