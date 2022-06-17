package("folly")
    set_homepage("https://github.com/facebook/folly")
    set_description("An open-source C++ library developed and used at Facebook.")
    set_license("Apache-2.0")

    add_urls("https://github.com/facebook/folly/releases/download/v$(version).00/folly-v$(version).00.zip",
             "https://github.com/facebook/folly.git")

    add_versions("2024.03.25", "3c57b0d1f1266e935aef1ed54535561fd2eeedc1aa946fbc46871e839014f74c")
    add_versions("2024.04.01", "f09e522c76a5f102c40c54726f6f255b0dc127c78f9c8c9ac117fc0f7ac284bb")
    add_versions("2024.06.10", "27d7f825a9a3469b59a4f0a5ba2edac733407ea8dcc036e7ca9279d803ece1e9")
    add_versions("2024.06.17", "a26cda1cf5f9914f2ff05b5f8e4062d73f5a1ff71ee1911e734dc758313f6d30")
    add_versions("2024.06.24", "05ce0aed45c3a8125334438564364fbf32cd0d80b2a58c010cc821f5f16def50")
    add_versions("2024.07.01", "a619f2759e821d4657aa9f1cae0dedcec2085e656e16a3c458e053a759d2ce83")
    add_versions("2024.07.08", "93c9c7c7e3cb30c1b4437ac3043c05a245383fbb6e558abda704d61f14dc67bd")
    add_versions("2024.07.15", "cbdd4400999c86d7ba271fdf3c15485ec5e250302aa98aebbca6f7e5715e6d8a")

    add_patches("<=2022.08.29", path.join(os.scriptdir(), "patches", "2021.06.28", "reorder.patch"), "9a6bf283881580474040cfc7a8e89d461d68b89bae5583d89fff0a3198739980")
    add_patches("<=2022.08.29", path.join(os.scriptdir(), "patches", "2021.06.28", "regex.patch"), "6a77ade9f48dd9966d3f7154e66ca8a5c030ae2b6d335cbe3315784aefd8f495")
    add_patches("<=2024.07.15", path.join(os.scriptdir(), "patches", "2023.11.20", "pkgconfig.patch"), "6838623d453418569853f62ad97c729e802a120c13d804aabba6d6455997e674")
    add_patches("<=2024.07.15", path.join(os.scriptdir(), "patches", "2023.11.20", "msvc.patch"), "1ee01c75528bd42736541022af461e44af3031c01d62c9342006f0abc0f44f2d")

    if is_plat("windows") then
        add_configs("shared", {description = "Build shared library.", default = false, type = "boolean", readonly = true})
    end

    add_deps("cmake")
    add_deps("conan::libiberty/9.1.0", {alias = "libiberty"})
    add_deps("openssl", {system=false})
    add_deps("boost", {system=false, configs = {all = true}})
    add_deps("libevent", {system=false, configs = {openssl = true}})
    add_deps("gflags", {system=false})
    add_deps("glog", {system=false})
    add_deps("fmt", {system=false})
    add_deps("zlib", {system=false})
    add_deps("double-conversion" ,{system=false})
    add_deps("bzip2", {system=false})
    add_deps("lz4", {system=false})
    add_deps("zstd", {optional = true}, {system=false})

    if is_plat("linux") then
        add_syslinks("pthread")
    end

    on_install("windows|x64", "linux", "macosx|x86_64", function (package)
        local configs = {"-DBUILD_TESTS=OFF",
                         "-DCMAKE_DISABLE_FIND_PACKAGE_LibDwarf=ON",
                         "-DCMAKE_DISABLE_FIND_PACKAGE_Libiberty=OFF",
                         "-DCMAKE_DISABLE_FIND_PACKAGE_LibAIO=ON",
                         "-DCMAKE_DISABLE_FIND_PACKAGE_LibURCU=ON",
                         "-DLIBAIO_FOUND=OFF",
                         "-DLIBURCU_FOUND=OFF",
                         "-DBOOST_LINK_STATIC=ON"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        if package:is_plat("windows") then
            table.insert(configs, "-DBoost_USE_STATIC_RUNTIME=" .. (package:config("vs_runtime"):startswith("MT") and "ON" or "OFF"))
        end
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <cassert>
            void test() {
                folly::CpuId id;
                assert(folly::kIsArchAmd64 == id.mmx());
            }
        ]]}, {configs = {languages = "c++17"}, includes = "folly/CpuId.h"}))
    end)
package_end()

