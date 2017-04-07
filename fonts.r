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
    if (! all(file.exists(file.path(path, paste0(font, complete_font_set))))) {
        # Build font metrics
        # TODO: How/why/what?!
        stop('Not yet implemented')
    }
}

rebuild_cache(extrafontdb_path)

font_paths = function (font, path) {
    file.path(path, paste0(font, complete_font_set))
}

make_font = function (name, basename, path) {
    ensure_font_exists(basename, path)
    Type1Font(name, font_paths(basename, path))
}

#' Register a PDF/postscript font
#'
#' @param name the font name.
#' @param basename the base filename used in the font metric filenames, if it
#' differs from the \code{name}.
#' @export
register_font = function (name, basename = name) {
    font = make_font(name, basename, extrafontdb_path)
    font_args = setNames(list(font), name)
    # TODO: Should this be a parameter?
    do.call(pdfFonts, font_args)
    do.call(postscriptFonts, font_args)
}

#' @rdname register_font
#' @export
register_fonts = function (names) {
    invisible(Map(register_font, names))
}
