package("asio")

    set_kind("library", {headeronly = true})
    set_homepage("http://think-async.com/Asio/")
    set_description("Asio is a cross-platform C++ library for network and low-level I/O programming that provides developers with a consistent asynchronous model using a modern C++ approach.")
    set_license("BSL-1.0")
    add_urls("https://github.com/chriskohlhoff/asio.git")

    if is_plat("mingw") then
        add_syslinks("ws2_32", "bcrypt")
    end

    on_install("!wasm", function (package)
        if os.isdir("asio") then
            os.cp("asio/include/asio.hpp", package:installdir("include"))
            os.cp("asio/include/asio", package:installdir("include"))
        else
            os.cp("include/asio.hpp", package:installdir("include"))
            os.cp("include/asio", package:installdir("include"))
        end
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test() {
                asio::io_context io_context;
                asio::steady_timer timer(io_context);
                timer.expires_at(asio::steady_timer::clock_type::time_point::min());
            }
        ]]}, {configs = {languages = "c++14"}, includes = "asio.hpp"}))
    end)
