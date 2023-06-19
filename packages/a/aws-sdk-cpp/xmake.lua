package("aws-sdk-cpp")
    set_homepage("https://github.com/aws/aws-sdk-cpp")
    set_description("AWS SDK for C++")

    add_urls("https://github.com/aws/aws-sdk-cpp.git")

    add_configs("build_only",  {type = "string", description = "", default = ""})

    add_deps("openssl", {system=false})
    add_deps("libcurl", {system=false})
    add_deps("zlib", {system=false})

    on_install("linux", function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=Release")
        table.insert(configs, "-DBUILD_SHARED_LIBS=OFF")
        if package:config("build_only") then
            table.insert(configs, "-DBUILD_ONLY=" .. string.gsub(package:config("build_only"), "+", ";"))
        end
        table.insert(configs, "-DENABLE_TESTING=OFF")
        table.insert(configs, "-DAUTORUN_UNIT_TESTS=OFF")
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({
            test = [[
              #include <aws/core/Aws.h>
              static void test() {
                Aws::SDKOptions options;
              }
            ]]
        }, {configs = {languages = "c++11"}}))
    end)

package_end()

