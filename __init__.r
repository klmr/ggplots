#' Pretty plotting module

export = import('./export', attach = 'export_from')

gg = import_package('ggplot2')
export_from(gg)

#
# Set a very minimal theme. Avoid chartjunk.
#

fonts = import('./fonts')
fonts$register_fonts(c('Roboto', 'Roboto Condensed'))

theme_set(theme_minimal() +
          theme(panel.grid = element_blank(),
                text = element_text(family = 'Roboto Condensed')))

.minimal_grid_lines = theme(panel.grid.major = theme_minimal()$panel.grid.major,
                            panel.grid.minor = theme_minimal()$panel.grid.minor)

# FIXME: Set font for geom_text/geom_label to “Roboto”
# FIXME: Disable grid lines for all plots except scatter and line charts.
# FIXME: enable major y grid lines for bar plots as well

# FIXME: The following does not work.
# geom_point = function (...) {
#     list(gg$geom_point(...), .minimal_grid_lines)
# }

# geom_line = function (...) {
#     list(gg$geom_line(...), .minimal_grid_lines)
# }

#
# Use Viridis for the default (discrete and continuous) color and fill scales.
#

scale_colour_discrete = function (...) viridis::scale_color_viridis(discrete = TRUE)
scale_color_discrete = scale_colour_discrete

scale_colour_continuous = viridis::scale_color_viridis
scale_color_continuous = scale_colour_continuous

scale_fill_discrete = function (...) viridis::scale_fill_viridis(discrete = TRUE)

scale_fill_continous = viridis::scale_fill_viridis

#
# Fix *some* of R’s many Unicode deficiencies of the PDF device.
#

# See <http://r.789695.n4.nabble.com/set-pdf-options-encoding-to-UTF-8-td902416.html>
# R News Volume 6/2, May 2006 (Non-Standard Fonts in PostScript and PDF
# Graphics) <https://cran.r-project.org/doc/Rnews/Rnews_2006-2.pdf>
# This is obviously an incredibly bad hack, but it does offer more than Latin-1.
pdf.options(encoding = 'ISOLatin2.enc')
