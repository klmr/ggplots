#' Pretty plotting module
'.__module__.'

#' @export
box::use(
    gg = ggplot2[...],
    ./fonts
)

#
# Set a very minimal theme. Avoid chartjunk.
#

theme_basic = function () {
    theme_minimal() + theme(panel.grid = element_blank())
}

#' @export
theme_fancy = function () {
    theme_basic() + theme(text = element_text(family = 'Roboto Condensed'))
}

#' @export
theme_publication = function () {
    theme_basic() + theme(text = element_text(family = 'Helvetica'))
}

minimal_grid_lines = theme(
    panel.grid.major = element_line(),
    panel.grid.minor = element_line()
)

#' @export
get_family = function () {
    theme_get()$text$family
}

#' @export
get_fontface = function () {
    theme_get()$text$face
}

#' @export
geom_point = function (...) {
    list(gg$geom_point(...), minimal_grid_lines)
}

#' @export
geom_line = function (...) {
    list(gg$geom_line(...), minimal_grid_lines)
}

#' @export
geom_step = function (...) {
    list(gg$geom_step(...), minimal_grid_lines)
}

#' @export
geom_text = function (..., family = get_family(), fontface = get_fontface()) {
    gg$geom_text(..., family = family, fontface = fontface)
}

#' @export
geom_label = function (..., family = get_family(), fontface = get_fontface()) {
    gg$geom_label(..., family = family, fontface = fontface)
}

#
# Use Viridis for the default (discrete and continuous) color and fill scales.
#

#' @export
scale_colour_discrete = function (...) viridis::scale_color_viridis(discrete = TRUE, ...)

#' @export
scale_color_discrete = scale_colour_discrete

#' @export
scale_colour_continuous = viridis::scale_color_viridis

#' @export
scale_color_continuous = scale_colour_continuous

#' @export
scale_fill_discrete = function (...) viridis::scale_fill_viridis(discrete = TRUE, ...)

#' @export
scale_fill_continous = viridis::scale_fill_viridis

#
# Add missing ggplot2 primitives
# (see <https://github.com/tidyverse/ggplot2/issues/1901> and
# <https://github.com/tidyverse/ggplot2/pull/4299>)
#

#' @export
scale_color_gray = gg$scale_color_grey

#' @export
scale_fill_gray = gg$scale_fill_grey

#
# Embed fonts when saving as PDF.
#

#' @export
ggsave = function (...) {
    filetype = tolower(tools::file_ext(filename))
    call = match.call()
    call[[1]] = quote(gg$ggsave)

    # Embedded Dingbats always cause problems in Adobe Illustrator because the
    # AdobePiStd font is improperly installed. Therefore disable it.
    if (filetype == 'pdf' && ! 'useDingbats' %in% names(call)) {
        call$useDingbats = FALSE
    }

    eval.parent(call)

    if (filetype %in% c('eps', 'ps', 'pdf')) {
        fonts$embed(filename)
    }
}

formals(ggsave) = formals(gg$ggsave)

.on_load = function (ns) {
    fonts$register_font('Roboto')
    fonts$register_font('Roboto Condensed', 'RobotoCondensed')

    theme_set(theme_fancy())

    # Fix *some* of R’s many Unicode deficiencies of the PDF device.

    # See <http://r.789695.n4.nabble.com/set-pdf-options-encoding-to-UTF-8-td902416.html>
    # R News Volume 6/2, May 2006 (Non-Standard Fonts in PostScript and PDF
    # Graphics) <https://cran.r-project.org/doc/Rnews/Rnews_2006-2.pdf>
    # This is obviously an incredibly bad hack, but it does offer more than Latin-1.
    grDevices::pdf.options(encoding = 'ISOLatin2.enc')
}
