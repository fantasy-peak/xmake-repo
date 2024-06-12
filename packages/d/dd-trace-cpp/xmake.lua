package("dd-trace-cpp")
    set_homepage("https://github.com/DataDog/dd-trace-cpp.git")
    set_description("Datadog distributed tracing for C++")
    set_license("Apache-2.0 license")

    -- -- add_deps("msgpack-cxx")
    -- add_deps("cmake", {system = false})
    add_deps("libcurl", {system = false})
    -- add_deps("opentracing-cpp 6db1a50770503ebd81bdd842d2c5c070ebdea664")
    add_deps("nlohmann_json")

    add_urls("https://github.com/DataDog/dd-trace-cpp.git")

    -- 0d89feb87f039dfc9bb9d599d259e0bb1091c96d
    -- add_urls("https://github.com/DataDog/dd-trace-cpp.git/archive/refs/tags/$(version).tar.gz")
    -- add_versions("v1.3.7", "8d39c6b23f941a2d11571daaccc04e69539a3fcbcc50a631837560d5861a7b96")

    on_install("linux", function (package)
        -- io.replace("CMakeLists.txt", "add_dependencies(dd_trace_cpp-objects libcurl)", "find_package(CURL REQUIRED)", {plain = true})
        -- -- io.replace("CMakeLists.txt", "libcurl", "${CURL_LIBRARIES}", {plain = true})
        io.replace("CMakeLists.txt", "CURL::libcurl_shared", "CURL::libcurl", {plain = true})
        io.replace("CMakeLists.txt", "CURL::libcurl_static", "CURL::libcurl", {plain = true})
        -- 6971362cdaf6aa476828873bd5333d02588a0c53 提交id
        io.replace("CMakeLists.txt", "include(cmake/deps/curl.cmake)", "find_package(CURL REQUIRED)", {plain = true})
        io.replace("CMakeLists.txt", "include(cmake/deps/json.cmake)", "find_package(PkgConfig)\npkg_check_modules(nlohmann_json REQUIRED nlohmann_json)", {plain = true})

        local configs = {}
        table.insert(configs, "-DBUILD_STATIC_LIBS=ON")
        table.insert(configs, "-DBUILD_SHARED_LIBS=OFF")
        table.insert(configs, "-DCMAKE_BUILD_TYPE=Release")
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <datadog/span_config.h>
            #include <datadog/tracer.h>
            #include <datadog/tracer_config.h>

            #include <chrono>
            #include <iostream>
            #include <thread>

            void test() {
                namespace dd = datadog::tracing;

                dd::TracerConfig config;
                config.service = "my-service";

                const auto validated_config = dd::finalize_config(config);
                if (!validated_config) {
                    std::cerr << validated_config.error() << '\n';
                    return;
                }

                dd::Tracer tracer{*validated_config};
                dd::SpanConfig options;

                options.name = "parent";
                dd::Span parent = tracer.create_span(options);

                std::this_thread::sleep_for(std::chrono::seconds(1));

                options.name = "child";
                dd::Span child = parent.create_child(options);
                child.set_tag("foo", "bar");

                std::this_thread::sleep_for(std::chrono::seconds(2));
            }
        ]]}, {configs = {languages = "c++17"}, includes = {"datadog/tracer.h"}}))
    end)

package_end()
