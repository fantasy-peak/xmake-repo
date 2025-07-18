package("nng")
    set_homepage("https://nng.nanomsg.org")
    set_description("NNG, like its predecessors nanomsg (and to some extent ZeroMQ), is a lightweight, broker-less library, offering a simple API to solve common recurring messaging problems.")
    set_license("MIT")

    add_urls("https://github.com/nanomsg/nng/archive/refs/tags/$(version).zip",
             "https://github.com/nanomsg/nng.git")

    add_versions("v1.11", "46a5a1567326824a5011249d4c10d3cd42ebbc32da3888759e9fa723505bb22f")
    add_versions("v1.10.2", "bd16a8a8be9f585d9def13b5d5a29e1fea4a6ef2f8a11eba7e670386f60a9e90")
    add_versions("v1.10.1", "ce209b0830c8dc69980cbd78aa39f4590a28799e7a00fd2b938a82cf740e7d9a")
    add_versions("v1.8.0", "48effcfd1acf31f6afcb1a92ecb4aa87f7993f5c54bf6587b0f4fb2606ce96d3")
    add_versions("v1.7.3", "72b39c63ba6467f6ee70c218c291240ff5b189569c3b84e8e0647f5d4d3888ea")
    add_versions("v1.5.2", "652ff3a2dbaeae194942205c369e9259e2b5cb5985d679d744cbfb95d1c807a3")
    add_versions("v1.4.0", "43674bb15d0f3810cf3602d2662cc91b6576b914492710244125e32b29f546b8")
    add_versions("v1.3.2", "2616110016c89ed3cbd458022ba41f4f545ab17f807546d2fdd0789b55d64471")

    -- default is false
    add_configs("NNG_ELIDE_DEPRECATED", {description = "Elide deprecated functionality.", default = false, type = "boolean"})
    add_configs("NNG_TRANSPORT_ZEROTIER", {description = "Enable ZeroTier transport (requires libzerotiercore).", default = false, type = "boolean"})
    add_configs("NNG_ENABLE_TLS", {description = "Enable TLS support.", default = false, type = "boolean"})

    -- default is true
    add_configs("NNG_ENABLE_STATS", {description = "Enable statistics.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_BUS0", {description = "Enable BUSv0 protocol.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_PAIR0", {description = "Enable PAIRv0 protocol.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_PAIR1", {description = "Enable PAIRv1 protocol.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_PUSH0", {description = "Enable PUSHv0 protocol.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_PULL0", {description = "Enable PULLv0 protocol.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_PUB0", {description = "Enable PUBv0 protocol.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_SUB0", {description = "Enable SUBv0 protocol.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_REQ0", {description = "Enable REQv0 protocol.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_REP0", {description = "Enable REPv0 protocol.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_RESPONDENT0", {description = "Enable RESPONDENTv0 protocol.", default = true, type = "boolean"})
    add_configs("NNG_PROTO_SURVEYOR0", {description = "Enable SURVEYORv0 protocol.", default = true, type = "boolean"})
    add_configs("NNG_ENABLE_HTTP", {description = "Enable HTTP API.", default = true, type = "boolean"})
    add_configs("NNG_TRANSPORT_INPROC", {description = "Enable inproc transport.", default = true, type = "boolean"})
    add_configs("NNG_TRANSPORT_IPC", {description = "Enable IPC transport.", default = true, type = "boolean"})
    add_configs("NNG_TRANSPORT_TCP", {description = "Enable TCP transport.", default = true, type = "boolean"})
    add_configs("NNG_TRANSPORT_TLS", {description = "Enable TLS transport.", default = true, type = "boolean"})
    add_configs("NNG_TRANSPORT_WS", {description = "Enable WebSocket transport.", default = true, type = "boolean"})
    add_configs("NNG_TRANSPORT_WSS", {description = "Enable WSS transport.", default = true, type = "boolean"})

    if is_plat("linux") then
        add_syslinks("pthread")
    elseif is_plat("windows") then 
        add_syslinks("ws2_32", "advapi32")
    end

    on_load(function (package)
        if not package:config("shared") then
            package:add("defines", "NNG_STATIC_LIB")
        end
        if package:config("NNG_ENABLE_TLS") then
            package:add("deps", "mbedtls")
        end
    end)

    add_deps("cmake")
    on_install("windows", "linux", "macosx", "android", "iphoneos", "cross", function(package)
        local configs = {"-DNNG_TESTS=OFF", "-DNNG_ENABLE_NNGCAT=OFF"}
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        for name, enabled in pairs(package:configs()) do
            if not package:extraconf("configs", name, "builtin") then
                table.insert(configs, "-D" .. name .. "=" .. (enabled and "ON" or "OFF"))
            end
        end
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function(package)
        assert(package:check_csnippets({test = [[
            #include <nng/nng.h>
            #include <nng/protocol/reqrep0/req.h>
            #include <nng/supplemental/util/platform.h>
            static void test() {
                nng_socket sock;
                int        rv;
                nng_req0_open(&sock);
                nng_close(sock);
            }
        ]]}, {includes = "nng/nng.h"}))
    end)
