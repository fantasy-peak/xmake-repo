package("libuuid")
    set_homepage("https://sourceforge.net/projects/libuuid")
    set_description("Portable uuid C library")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/fantasy-peak/libuuid.git")

    on_install("!windows and !mingw", function(package)
        io.writefile("xmake.lua", [[
            includes("@builtin/check")
            add_rules("mode.debug", "mode.release")
            target("uuid")
                set_kind("$(kind)")
                add_files("*.c|test_*.c")
                add_headerfiles("*.h", {prefixdir = "uuid"})
                add_rules("utils.install.pkgconfig_importfiles", {filename = "uuid.pc"})
                check_cincludes("HAVE_DLFCN_H", "dlfcn.h")
                check_cincludes("HAVE_FCNTL_H", "fcntl.h")
                check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
                check_cincludes("HAVE_LIMITS_H", "limits.h")
                check_cincludes("HAVE_MEMORY_H", "memory.h")
                check_cincludes("HAVE_NETINET_IN_H", "netinet/in.h")
                check_cincludes("HAVE_STDINT_H", "stdint.h")
                check_cincludes("HAVE_STDLIB_H", "stdlib.h")
                check_cincludes("HAVE_STRING_H", "string.h")
                check_cincludes("HAVE_STRINGS_H", "strings.h")
                check_cincludes("HAVE_SYS_FILE_H", "sys/file.h")
                check_cincludes("HAVE_SYS_IOCTL_H", "sys/ioctl.h")
                check_cincludes("HAVE_SYS_SOCKET_H", "sys/socket.h")
                check_cincludes("HAVE_SYS_STAT_H", "sys/stat.h")
                check_cincludes("HAVE_SYS_TIME_H", "sys/time.h")
                check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
                check_cfuncs("HAVE_FTRUNCATE", "ftruncate", {includes = "unistd.h"})
                check_cfuncs("HAVE_GETTIMEOFDAY", "gettimeofday", {includes = "sys/time.h"})
                check_cfuncs("HAVE_MEMSET", "memset", {includes = "string.h"})
                check_cfuncs("HAVE_SOCKET", "socket", {includes = "sys/socket.h"})
                check_cfuncs("HAVE_SRANDOM", "srandom", {includes = "stdlib.h"})
                check_cfuncs("HAVE_STRTOUL", "strtoul", {includes = "stdlib.h"})
                check_cfuncs("HAVE_USLEEP", "usleep", {includes = "unistd.h"})
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function(package)
        assert(package:check_csnippets({
            test = [[
                void test() {
                    uuid_t buf;
                    char str[100];
                    uuid_generate(buf);
	                uuid_unparse(buf, str);
                }
            ]]
        }, {configs = {languages = "c11"}, includes = "uuid/uuid.h"}))
    end)
