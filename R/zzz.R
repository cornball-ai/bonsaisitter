.onLoad <- function(libname, pkgname) {
    library.dynam("bonsaisitter", pkgname, libname)
}

.onUnload <- function(libpath) {
    library.dynam.unload("bonsaisitter", libpath)
}
