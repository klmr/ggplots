extrafontdb_path = try(system.file('metrics', package = 'extrafontdb', mustWork = TRUE), silent = TRUE)
# FIXME: Make this work with un-gzipped font metrics as well.
# FIXME: Make this work with incomplete fonts.
complete_font_set = paste0(c('-Regular', '-Bold', '-Italic', '-BoldItalic'), '.afm.gz')

rebuild_cache = function (path) {
    if (inherits(path, 'try-error')) {
        # Build extrafontdb cache
        extrafontdb = try(loadNamespace('extrafont'), silent = TRUE)
        if (inherits(extrafont, 'try-error')) {
            install.packages('extrafont')
            extrafont = loadNamespace('extrafont')
        }
    }
}

ensure_font_exists = function (font, path) {
    if (! file.exists(file.path(path, paste0(font, complete_font_set)))) {
        # Build font metrics
        # TODO: How/why/what?!
        stop('Not yet implemented')
    }
}

rebuild_cache(extrafontdb_path)

complete_font = function (name) {
    paste0(name, complete_font_set)
}

font_paths = function (name, path) {
    file.path(path, complete_font(name))
}

make_font = function (name, path) {
    ensure_font_exists(name, path)
    Type1Font(name, font_paths(name, path))
}

#' @export
register_font = function (name) {
    font = make_font(name, extrafontdb_path)
    font_args = setNames(list(font), name)
    # TODO: Should this be a parameter?
    do.call(pdfFonts, font_args)
    do.call(postscriptFonts, font_args)
}

#' @export
register_fonts = function (names) {
    invisible(Map(register_font, names))
}
