box::use(
    extrafont,
    grDevices[embedFonts, pdfFonts, postscriptFonts, Type1Font],
    stats[setNames]
)

ensure_font_exists = function (font, path) {
    if (! all(file.exists(file.path(path, paste0(font, complete_font_set))))) {
        # Build font metrics
        extrafont$ttf_import(pattern = rx_escape(font))
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
    do.call('pdfFonts', font_args)
    do.call('postscriptFonts', font_args)
}

#' Embed fonts into a generated plot file
#'
#' @param filename the filename of the plot file.
#' @param format the format for the new file; see
#' \code{\link[grDevices]{embedFonts}}. If not provided, \code{"eps2write"} is
#' used for EPS files, \code{"ps2write"} for PS, and \code{"pdfwrite"} for PDF.
#' @export
embed = function (filename, format) {
    box::use(tools)
    if (missing(format)) {
        format = switch(
            tolower(tools$file_ext(filename)),
            eps = 'eps2write', ps = 'ps2write', pdf = 'pdfwrite'
        )
    }

    fontmap = system.file('fontmap', package = 'extrafontdb')
    embedFonts(
        filename, format, filename,
        options = paste0('-I', shQuote(fontmap))
    )
}

.on_load = function(ns) {
    ns$extrafontdb_path = system.file('metrics', package = 'extrafontdb', mustWork = TRUE)
    ns$complete_font_set = paste0(c('-Regular', '-Bold', '-Italic', '-BoldItalic'), '.afm.gz')
}
