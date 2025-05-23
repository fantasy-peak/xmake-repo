package("ozz-animation")
    set_homepage("http://guillaumeblanc.github.io/ozz-animation/")
    set_description("Open source c++ skeletal animation library and toolset")
    set_license("MIT")

    add_urls("https://github.com/guillaumeblanc/ozz-animation/archive/refs/tags/$(version).tar.gz",
             "https://github.com/guillaumeblanc/ozz-animation.git")

    add_versions("0.16.0", "a7a34322344e9d839eaf637bbc463404c6aed3f52583dea95c856fea580c2693")
    add_versions("0.15.0", "2a995b921e4244c419f1c3a4dc4aa0805c0dc40fa32244a24cf64125e87161ae")
    add_versions("0.14.3", "1ab7d2fbf4c5a79aafac43cbd41ac9cff1e7f750248bee5141da5ee2d893cefe")
    add_versions("0.14.2", "52938e5a699b2c444dfeb2375facfbb7b1e3d405b424e361ad1a27391a53b89a")

    add_configs("fbx", {description = "Build Fbx pipeline (Requires Fbx SDK)", default = false, type = "boolean"})
    add_configs("gltf", {description = "Build glTF importer", default = false, type = "boolean"})
    add_configs("data", {description = "Build data on code change", default = false, type = "boolean"})
    add_configs("simd_ref", {description = "Force SIMD math reference implementation", default = false, type = "boolean"})
    add_configs("postfix", {description = "Use per config postfix name", default = false, type = "boolean"})
    add_configs("tools", {description = "Build tools", default = false, type = "boolean"})

    add_deps("cmake")

    add_links("ozz_animation", "ozz_animation_offline", "ozz_geometry", "ozz_options", "ozz_base")

    on_install(function (package)
        if package:config("shared") then
            package:add("defines", "OZZ_USE_DYNAMIC_LINKING")
        end

        io.replace("build-utils/cmake/compiler_settings.cmake", "add_compile_options(/WX)", "", {plain = true})
        io.replace("build-utils/cmake/compiler_settings.cmake", "add_compile_options(-Werror)", "", {plain = true})
        io.replace("build-utils/cmake/compiler_settings.cmake", [[set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")]], "", {plain = true})
        io.replace("build-utils/cmake/compiler_settings.cmake", [[set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")]], "", {plain = true})

        local configs =
        {
            "-Dozz_build_samples=OFF",
            "-Dozz_build_tests=OFF",
            "-Dozz_build_howtos=OFF",
            "-Dozz_run_tests_headless=OFF",
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        for name, enabled in pairs(package:configs()) do
            if not package:extraconf("configs", name, "builtin") then
                table.insert(configs, "-Dozz_build_" .. name .. "=" .. (enabled and "ON" or "OFF"))
            end
        end
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        local languages
        if package:version() and package:version():ge("0.16.0") then
            languages = "c++17"
        else
            languages = "c++11"
        end
        assert(package:check_cxxsnippets({test = [[
            #include <ozz/animation/runtime/animation.h>
            void test() {
                auto x = ozz::animation::Animation();
            }
        ]]}, {configs = {languages = languages}}))
    end)
