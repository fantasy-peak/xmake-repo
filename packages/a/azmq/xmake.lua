package("azmq")

    set_homepage("https://github.com/zeromq/azmq")
    set_description("C++ language binding library integrating ZeroMQ with Boost Asio")
    set_license("BSL-1.0 license")

    add_urls("https://github.com/zeromq/azmq.git")

    add_deps("cmake")
    add_deps("cppzmq", {system=false})
    -- add_deps("zeromq")
    -- == system date_time thread chrono random
    add_deps("boost", {configs = {all = true}})
    -- apt-get install pkg-config
    -- apt install libmsgpack-dev/jammy
    -- apt install libboost-all-dev/jammy
    -- apt install libzmq3-dev/jammy
    on_install("macosx", "linux", "windows", "mingw", "cross", function (package)
        local configs = {"-DAZMQ_BUILD_TESTS=OFF"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DAZMQ_BUILD_DOC=OFF")
        table.insert(configs, "-DAZMQ_DEVELOPER=OFF")
        import("package.tools.cmake").install(package, configs)
    end)

package_end()
