package("resource_pool")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/elsid/resource_pool.git")
    set_description("C++ header only library purposed to create pool of some resources like keepalive connections")

    add_urls("https://github.com/elsid/resource_pool.git")

    add_deps("boost")

    on_install("windows", "macosx", "linux", "mingw", function (package)
        os.cp("include", package:installdir())
    end)
