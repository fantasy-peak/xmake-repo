package("trantor")
    set_homepage("https://github.com/fantasy-peak/trantor.git")
    set_description("a non-blocking I/O tcp network lib based on c++14/17")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/fantasy-peak/trantor.git")

    add_deps("cmake")
    add_deps("openssl", {system=false})
    add_deps("c-ares", {optional = true})
    if is_plat("windows") or is_plat("mingw") then
        add_syslinks("ws2_32")
    elseif is_plat("linux") then
        add_syslinks("pthread")
    end
    on_install("windows", "macosx", "linux", "mingw@windows", function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        if package:config("pic") ~= false then
            table.insert(configs, "-DCMAKE_POSITION_INDEPENDENT_CODE=ON")
        end
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <thread>
            #include <chrono>
            using namespace std::chrono_literals;
            void test() {
                trantor::SerialTaskQueue queue("");
                queue.runTaskInQueue([&]() {
                    for (int i = 0; i < 5; ++i)
                        std::this_thread::sleep_for(0.1s);
                });
                queue.waitAllTasksFinished();
            }
        ]]}, {configs = {languages = "c++17"}, includes = "trantor/utils/SerialTaskQueue.h"}))
    end)
