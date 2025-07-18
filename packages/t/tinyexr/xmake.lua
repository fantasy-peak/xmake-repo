package("tinyexr")
    set_homepage("https://github.com/syoyo/tinyexr/")
    set_description("Tiny OpenEXR image loader/saver library")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/syoyo/tinyexr/archive/refs/tags/$(version).tar.gz",
             "https://github.com/syoyo/tinyexr.git")

    add_versions("v1.0.12", "e3383703d6eaf175a3f36dfc23ec5c8a22e61ddc3acd05dd442cb33ce7af0d39")
    add_versions("v1.0.10", "d2e4cef7ec1ad48e5c363171d15458def77749221db8510bfdfd68cd927fe6cc")
    add_versions("v1.0.9", "f9e05127c3db23f9c4269c9a922ed0d3d911486efd884883e1f01b0ee19de91e")
    add_versions("v1.0.1", "4dbbd8c7d17597ad557518de5eb923bd02683d26d0de765f9224e8d57d121677")
    add_versions("v1.0.8", "b56446533f36496c3c76b8e4f664f04736b173c5e3f4903f6edff3753f363302")

    add_deps("miniz")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            add_requires("miniz")
            target("tinyexr")
                set_kind("$(kind)")
                set_languages("c++11")
                add_files("tinyexr.cc")
                add_headerfiles("tinyexr.h")
                add_packages("miniz")
                if is_plat("windows") and is_kind("shared") then
                    add_rules("utils.symbols.export_all")
                end
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:has_cxxfuncs("IsEXR", {includes = "tinyexr.h"}))
    end)
