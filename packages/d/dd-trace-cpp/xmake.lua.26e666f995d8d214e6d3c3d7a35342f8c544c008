package("dd-trace-cpp")
    set_homepage("https://github.com/DataDog/dd-trace-cpp.git")
    set_description("Datadog distributed tracing for C++")
    set_license("Apache-2.0 license")

    -- -- add_deps("msgpack-cxx")
    add_deps("libcurl", {system = false})
    -- add_deps("opentracing-cpp 6db1a50770503ebd81bdd842d2c5c070ebdea664")

    add_urls("https://github.com/DataDog/dd-trace-cpp.git")

    -- 0d89feb87f039dfc9bb9d599d259e0bb1091c96d
    -- add_urls("https://github.com/DataDog/dd-trace-cpp.git/archive/refs/tags/$(version).tar.gz")
    -- add_versions("v1.3.7", "8d39c6b23f941a2d11571daaccc04e69539a3fcbcc50a631837560d5861a7b96")

    on_install("linux", function (package)
        io.replace("CMakeLists.txt", "add_dependencies(dd_trace_cpp-objects libcurl)", "find_package(CURL REQUIRED)", {plain = true})
        -- io.replace("CMakeLists.txt", "libcurl", "${CURL_LIBRARIES}", {plain = true})
        io.replace("CMakeLists.txt", "libcurl", "CURL::libcurl", {plain = true})
        io.replace("CMakeLists.txt", "include(cmake/deps/curl.cmake)", "include_directories(${CURL_INCLUDE_DIR})", {plain = true})
        local configs = {}
        table.insert(configs, "-DBUILD_STATIC_LIBS=ON")
        table.insert(configs, "-DCMAKE_BUILD_TYPE=Release")
        import("package.tools.cmake").install(package, configs)
    end)

package_end()

