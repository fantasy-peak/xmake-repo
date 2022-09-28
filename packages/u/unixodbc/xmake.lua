package("unixodbc")
    set_homepage("https://github.com/lurcher/unixODBC.git")
    set_description("unixODBC")
    set_license("")

    add_urls("https://github.com/lurcher/unixODBC/releases/download/2.3.11/unixODBC-$(version).tar.gz",
             "https://github.com/lurcher/unixODBC.git")
    add_versions("2.3.11", "d9e55c8e7118347e3c66c87338856dad1516b490fb7c756c1562a2c267c73b5c")

    on_install("linux", function (package)
        os.exec("./configure --prefix=" .. package:installdir() .. " --sysconfdir=" .. package:installdir() .. "/etc --enable-gui=no --disable-nls --enable-static --disable-shared")
        import("package.tools.make").install(package)
    end)

