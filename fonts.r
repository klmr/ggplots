create_extrafontdb = function () {
    extrafontdb_path = function ()
        system.file('metrics', package = 'extrafontdb', mustWork = TRUE)

    path = try(extrafontdb_path(), silent = TRUE)

    # If extrafontdb doesn’t exist, this means that the extrafont package isn’t
    # installed. Reinstalling it will re-create the extrafont database.

    if (inherits(path, 'try-error')) {
        install.packages('extrafont')
        # Afterwards the path will exist.
        path = extrafontdb_path()
    }
    path
}

ensure_font_exists = function (font, path) {
    if (! all(file.exists(file.path(path, paste0(font, complete_font_set))))) {
        # Build font metrics
        extrafont::ttf_import(pattern = rx_escape(font))
    }
}

rx_escape = function (regex) {
    # Adapted from <https://github.com/benjamingr/RegExp.escape>
    gsub('([\\\\^$*+?.()|[\\]{}])', '\\\\\\1', regex, perl = TRUE)
}

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

extrafontdb_path = create_extrafontdb()
complete_font_set = paste0(c('-Regular', '-Bold', '-Italic', '-BoldItalic'), '.afm.gz')
