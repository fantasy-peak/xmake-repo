package("ozo")
    set_homepage("https://github.com/yandex/ozo")
    set_description("OZO is a C++17 Boost.Asio based header-only library for asyncronous communication with PostgreSQL DBMS.")
    set_license("PostgreSQL license")

    add_urls("https://github.com/yandex/ozo.git")
    -- add_versions("v1.11.0", "a20f2d9df805b16ac75ab4da0a230d3d1c304127d719e5c66a4e6df514e7f6c0")
    -- add_versions("v1.12.0", "052ad3d5dad358a33606e0fc89483f8150bb0655c99b12a43aa58b5b7f0cc507")

    add_deps("cmake")
    add_deps("boost", {system=false, configs = {all = true}})
    add_deps("libpq")

    -- on_load("linux", function (package)
    --     package:add("defines", "ONNX_ML")
    --     package:add("defines", "ONNX_NAMESPACE=onnx")
    -- end)

    on_install("linux", "macosx", "windows|x64", "windows|x86", function (package)
        local configs = {}
        table.insert(configs, "-DOZO_BUILD_TESTS=OFF")
        -- table.insert(configs, "-DBOOST_HANA_CONFIG_ENABLE_STRING_UDL=ON")
        -- table.insert(configs, "-DBOOST_ASIO_USE_TS_EXECUTOR_AS_DEFAULT=ON")
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        -- assert(package:check_cxxsnippets({test = [[
        --     #define BOOST_HANA_CONFIG_ENABLE_STRING_UDL
        --     #define BOOST_ASIO_USE_TS_EXECUTOR_AS_DEFAULT
        --     #include <ozo/connection_info.h>
        --     #include <ozo/connection_pool.h>
        --     void test() {
        --         ozo::connection_info connection_info("");
        --         ozo::connection_pool_config connection_pool_config;
        --     }
        -- ]]}, {configs = {languages = "c++20"}, includes = {"ozo/connection_info.h", "ozo/connection_pool.h", ""}}))
    end)
