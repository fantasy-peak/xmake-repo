package("libmysql")
    -- set_kind("library", {headeronly = true})
    set_homepage("https://github.com/boostorg/mysql.git")
    set_description("")
    set_license("")

    add_urls("https://github.com/boostorg/mysql.git")

    add_deps("openssl", {system=false})
    add_deps("boost", {system=false, configs = {all = true}})

    if is_plat("linux") then
        add_syslinks("pthread")
    end

    on_install("windows|x64", "linux", "macosx", function (package)
        os.cp("include/*", package:installdir("include"))
    end)

package_end()
