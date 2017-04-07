#' Export symbols from a module environment
#'
#' @param env the module environment to export from.
#' @param symbols a character vector of symbol names to export. If \code{NULL}
#' (the default), export every public symbol.
#' @param target the environment to import the symbols into; default: the
#' calling environment.
export_from = function (env, symbols = NULL, target = parent.frame()) {
    if (is.null(symbols)) symbols = ls(env)
    # FIXME: This will stop working once ‹modules› requires explicitly marked
    # exports.
    invisible(list2env(mget(symbols, env), target))
}
