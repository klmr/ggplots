#' Pretty plotting module

export = import('./export', attach = 'export_from')

gg = import_package('ggplot2')
export_from(gg)

#
# Set a very minimal theme. Avoid chartjunk.
#

fonts = import('./fonts')
fonts$register_font('Roboto')
fonts$register_font('Roboto Condensed', 'RobotoCondensed')

.theme_basic = function () {
    theme_minimal() + theme(panel.grid = element_blank())
}

theme_fancy = function () {
    .theme_basic() + theme(text = element_text(family = 'Roboto Condensed'))
}

theme_publication = function () {
    .theme_basic() + theme(text = element_text(family = 'Helvetica'))
}

theme_set(theme_fancy())

.minimal_grid_lines = theme(panel.grid.major = element_line(),
                            panel.grid.minor = element_line())

get_family = function () {
    theme_get()$text$family
}

get_fontface = function () {
    theme_get()$text$face
}

geom_point = function (...) {
    list(gg$geom_point(...), .minimal_grid_lines)
}

geom_line = function (...) {
    list(gg$geom_line(...), .minimal_grid_lines)
}

geom_step = function (...) {
    list(gg$geom_step(...), .minimal_grid_lines)
}

geom_text = function (..., family = get_family(), fontface = get_fontface()) {
    gg$geom_text(..., family = family, fontface = fontface)
}

geom_label = function (..., family = get_family(), fontface = get_fontface()) {
    gg$geom_label(..., family = family, fontface = fontface)
}

#
# Use Viridis for the default (discrete and continuous) color and fill scales.
#

scale_colour_discrete = function (...) viridis::scale_color_viridis(discrete = TRUE, ...)
scale_color_discrete = scale_colour_discrete

scale_colour_continuous = viridis::scale_color_viridis
scale_color_continuous = scale_colour_continuous

scale_fill_discrete = function (...) viridis::scale_fill_viridis(discrete = TRUE, ...)

scale_fill_continous = viridis::scale_fill_viridis

#
# Add missing ggplot2 primitives
# (<https://github.com/tidyverse/ggplot2/issues/1901>)
#

scale_color_gray = gg$scale_color_grey

scale_fill_gray = gg$scale_fill_grey

#
# Fix *some* of R’s many Unicode deficiencies of the PDF device.
#

# See <http://r.789695.n4.nabble.com/set-pdf-options-encoding-to-UTF-8-td902416.html>
# R News Volume 6/2, May 2006 (Non-Standard Fonts in PostScript and PDF
# Graphics) <https://cran.r-project.org/doc/Rnews/Rnews_2006-2.pdf>
# This is obviously an incredibly bad hack, but it does offer more than Latin-1.
pdf.options(encoding = 'ISOLatin2.enc')
