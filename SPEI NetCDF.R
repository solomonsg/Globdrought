# Compute SPEI at various time scales from very large netCDF files,
# using parallel computing. The resulting netCDF files are stored
# details provided in https://github.com/sbegueria/SPEIbase
# to disk on directory './outputNcdf/'.
# Using SPEI package version 1.7.2. Please, note that this will replace any
# other version of the SPEI package that you might have installed!
#devtools::install_github('sbegueria/SPEI@v1.7.2')

library(ncdf4)
library(snow)
library(snowfall)
library(parallel)
library(SPEI)
library (parallel)

# A function to efficiently compute the SPEI over a large netCDF file (using multiple cores).
source('./functions.R')

# Initialize a parallel computing cluster; modify the parameter `cpus` to the
# desired number of cores; otherwise, it will use all available cores.
sfInit(parallel=TRUE, cpus=20)  # change cpus depending on availability 
sfExport(list='spei', namespace='SPEI')

# Compute SPEI at all time scales between 1 and 48 and store to disk.
for (i in c(6)) {
    spei.nc(
      sca=i,
		  inPre='MSWEP_Global_pr_1981-2022.nc',                         # Precipiation 
		  inEtp='Global_Ep_1981-2022_GLEAM_v4.2a.nc',					# ETP (AED)
		  outFile=paste('spei6',										# output(netcdf)
		              formatC(i, width=2, format='d', flag='0'),'.nc',sep=''),
		  title=paste('Global ',i,'-month',
		            ifelse(i==1,'','s'),' SPEI, z-values, 0.05 degree',sep=''),
		  comment='Using MSWEP_v2 precipitation and GLEAM_v4 potential evapotranspiration data',
		  block=36,
		  inMask=NA,
		  tlapse=NA
	  )
  gc()
}

# Stop the parallel cluster
sfStop()

# Print session information
sessionInfo()
