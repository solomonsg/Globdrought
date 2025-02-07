library(ncdf4)
library(trend)
library(Kendall)

rm(list=ls())
setwd ("")
# Open the NetCDF file
prec_month_max <- nc_open("HRSPEI_GLEAM4spei06.nc")
lon <- ncvar_get(prec_month_max, varid = "lon")
lat <- ncvar_get(prec_month_max, varid = "lat")
time <- ncvar_get(prec_month_max, varid = "time")
nx <- length(lon)
ny <- length(lat)
nt <- length(time)

obs <- ncvar_get(prec_month_max, "spei")

print("calc rl")
rl = array(0, c(nx, ny))
mk = array(0, c(nx, ny))
pv = array(0, c(nx, ny))

for (x in 1:nx) {
  print(x)
  for (y in 1:ny) {
    tryCatch({
      Rr = ts(obs[x, y, ], start = c(1981), frequency = 12)
      Rr=Rr[-(1:6)] 
      slp = sens.slope(Rr)
      rl[x, y] = slp$estimates
      
      mk_res = MannKendall(Rr)
      tau = mk_res$tau[1]
      pvalue = mk_res$sl[1]
      mk[x, y]=tau
      pv[x, y]=pvalue
      
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  }
}

time <- ncdim_def("Time", "months", 1, unlim=TRUE)
lons <- ncdim_def("longitude", "degrees_east", lon)
lats <- ncdim_def("latitude", "degrees_north", lat)
var_temp_rl <- ncvar_def("sens_slope", "years", list(lons, lats, time), longname="Sen's slope") 
var_temp_mk <- ncvar_def("mk", "years", list(lons, lats, time), longname="Modified MK trend") 
var_temp_pv <- ncvar_def("pv", "years", list(lons, lats, time), longname="Pvalue") 

ncnew <- nc_create("HRSPEI_GLEAMv4_spei06_1981-2022_MK.nc", list(var_temp_rl, var_temp_mk, var_temp_pv))
ncvar_put(ncnew, var_temp_rl, rl, start = c(1, 1, 1), count = c(nx, ny, 1))
ncvar_put(ncnew, var_temp_mk, mk, start = c(1, 1, 1), count = c(nx, ny, 1))
ncvar_put(ncnew, var_temp_pv, pv, start = c(1, 1, 1), count = c(nx, ny, 1))
nc_close(ncnew)
