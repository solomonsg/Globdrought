# Globdrought
Code for Drought Indices and Trends Calculation
# Global Mann-Kendall Trend Analysis and SPEI Calculation  
## Overview  
This repository contains R scripts for calculating and visualizing the **Standardized Precipitation Evapotranspiration Index (SPEI)** and performing **Mann-Kendall (MK) trend analysis** on a global scale. The scripts generate trend maps and other visual outputs for analyzing long-term hydroclimatic trends.  
## Features  
- **SPEI Calculation:** Computes the Standardized Precipitation Evapotranspiration Index (SPEI) for different time scales.  
- **Mann-Kendall Trend Analysis:** Detects trends in global SPEI time series.  
- **Spatial Visualization:** Uses `rasterVis` and `latticeExtra` to plot trends over global datasets.  
- **NetCDF Data Handling:** Reads and processes NetCDF files containing climate variables.  
- **Shapefile Integration:** Overlays country/continent boundaries on plots for better visualization.  

## Dependencies  
Ensure the following R packages are installed before running the scripts:  
```r
install.packages(c("raster", "spei","ncdf4", "SPEI", "Kendall", "trend", "rasterVis", "sp", "latticeExtra"))
