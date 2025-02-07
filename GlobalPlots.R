library(raster)
library(ncdf4)
library(RColorBrewer)
library(rasterVis)
library(maptools)

setwd("")

crswgs84=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
world=readShapePoly("World_Continents.shp")

spei6=raster("HRSPEI_GLEAMv4_spei06_1981-2022_MK.nc", varname="sens_slope")
lists = list(title="z-units\n/year", labels=list(cex=1.0), height=0.8, width=1.4, space= "bottom")
plotmk = levelplot(spei6, margin=FALSE, layout=c(1,1), 
                   scales = list(x = list(draw = FALSE), y = list(draw = FALSE)),  
                   xlab="", ylab="", 
                   cex.lab=1,  
                   par.strip.text=list(cex=1), cex=1.0,
                   par.settings = list(
                     axis.line = list(col="white"),
                    strip.background = list(col="white"),
                    strip.border = list(col="white"),
                     background = list(col="white")),
                   colorkey = lists, main="Mann-Kendall Trend Analysis of SPEI-06") + 
  latticeExtra::layer(sp.polygons(world, col="black"))

diverge0 <- function(p, ramp) {    
# copied from https://gist.github.com/scbrown86/2c44d1cf59a5658c4dabf30742119519 
# p: a trellis object resulting from rasterVis::levelplot
# ramp: the name of an RColorBrewer palette (as character), a character 
#       vector of colour names to interpolate, or a colorRampPalette.
if(length(ramp)==1 && is.character(ramp) && ramp %in% 
   row.names(brewer.pal.info)) {
  ramp <- suppressWarnings(colorRampPalette(brewer.pal(11, ramp)))
} else if(length(ramp) > 1 && is.character(ramp) && all(ramp %in% colors())) {
  ramp <- colorRampPalette(ramp)
} else if(!is.function(ramp))
  stop('ramp should be either the name of a RColorBrewer palette, ', 
       'a vector of colours to be interpolated, or a colorRampPalette.')
rng <- range(p$legend[[1]]$args$key$at)
s <- seq(-max(abs(rng)), max(abs(rng)), len=1001)
i <- findInterval(rng[which.min(abs(rng))], s)
zlim <- switch(which.min(abs(rng)), `1`=i:(1000+1), `2`=1:(i+1))
p$legend[[1]]$args$key$at <- s[zlim]
p[[grep('^legend', names(p))]][[1]]$args$key$col <- ramp(1000)[zlim[-length(zlim)]]
p$panel.args.common$col.regions <- ramp(1000)[zlim[-length(zlim)]]
p
}

# plot global trend using divergent colors 

diverge0(plotmk, ramp=colorRampPalette(c("#A50026", "#D73027" ,"#F46D43", "#FDAE61" ,"#FEE090",  "#E0F3F8", "#ABD9E9", "#74ADD1", "#4575B4", "#313695")))

#or 
diverge0(plotmk, ramp="RdBu")   #choose colors from RColorBrewer