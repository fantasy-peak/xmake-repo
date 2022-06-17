package("folly")
    set_homepage("https://github.com/facebook/folly")
    set_description("An open-source C++ library developed and used at Facebook.")
    set_license("Apache-2.0")

    add_urls("https://github.com/facebook/folly/releases/download/v$(version).00/folly-v$(version).00.zip",
             "https://github.com/facebook/folly.git")
    add_versions("2022.04.11", "a61cc06c622ba7c8fbae7edc1d134ffb8c7996e1e7fd2d272624172254a5eff1")
    add_versions("2022.04.25", "7d5cd59613780d7d2b9c946c810bfd6b0d11ed3a8a74c5ab00d4e9de5d1b2104")
    add_versions("2022.08.29", "3adac6d4b203c2917185fd190fc04d615051cb2a4f6b988ddf3c42034efc8d4d")

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

    on_install("windows|x64", "linux", "macosx", function (package)
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
