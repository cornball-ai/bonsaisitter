.onLoad <- function(libname, pkgname) {
    library.dynam("treesitR", pkgname, libname)
}

.onUnload <- function(libpath) {
    library.dynam.unload("treesitR", libpath)
}
