package("quickfix")
    set_homepage("https://github.com/quickfix/quickfix")
    set_description("QuickFIX C++ Fix Engine Library")
    set_license("QuickFIX Software License")

    add_urls("https://github.com/quickfix/quickfix.git")

    -- add_versions("v1.15.1", "1c4322a68704526ca3d1f213e7b0dcd30e067a8815be2a79b2ab1197ef70dcf7")

    add_deps("cmake")

    if is_plat("linux") then
        add_syslinks("pthread")
    end

    on_install(function (package)
        local configs = {"-DHAVE_SSL=OFF"}
        table.insert(configs, "-DQUICKFIX_EXAMPLES=OFF")
        table.insert(configs, "-DQUICKFIX_TESTS=OFF")
        table.insert(configs, "-DQUICKFIX_SHARED_LIBS=OFF")
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
    end)
