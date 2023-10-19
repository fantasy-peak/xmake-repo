package("curl-multi-asio")
    set_homepage("https://github.com/fantasy-peak/curl-multi-asio.git")
    set_description("")
    set_license("MIT")

    add_urls("https://github.com/fantasy-peak/curl-multi-asio.git")

    add_deps("boost")

    on_install("linux", "macosx", function (package)
        local asio_dir = package:dep("boost"):installdir("include")
        local configs = {"-DCMA_ASIO_INCLUDE_DIR=" .. asio_dir}
        table.insert(configs, "-DCMA_MANAGE_CURL=OFF")
        table.insert(configs, "-DCMA_BUILD_EXAMPLES=OFF")
        table.insert(configs, "-DCMA_USE_BOOST=ON")
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        import("package.tools.cmake").install(package, configs, {buildir = "build"})
        os.cp("build/src/libcurl-multi-asio.a", package:installdir("lib"))
        os.cp("include/*", package:installdir("include"))
    end)


