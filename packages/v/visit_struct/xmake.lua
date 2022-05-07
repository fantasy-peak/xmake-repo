
package("visit_struct")
set_homepage("https://github.com/garbageslam/visit_struct.git")
set_description("")
set_license("")

add_urls("https://github.com/garbageslam/visit_struct.git")

on_install("linux", function (package)
    os.cp("include", package:installdir())
end)
package_end()