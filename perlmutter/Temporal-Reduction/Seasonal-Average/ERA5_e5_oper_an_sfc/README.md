ERA5-Seasonal-Average
==========================
This repo contains batch scripts illustrating computing seasonal averages
of TCWV (total cumulative water vapor) from a high resolution reanalysis dataset (ERA5) using
[TECA](https://github.com/LBL-EESA/TECA).

The data used in this example is located on NERSC's Cori file system at:
```
/global/cfs/cdirs/m3522/cmip6/ERA5/e5.oper.an.sfc/
```
This 0.25 degree, 1 hourly resolution dataset spans 43 years from Jan 1 1979 to
Jun 30 2021.  The data is stored on disk with, each file containing the data
for a single variable for one month. Each month's data is placed in a separate
directory.  The dataset contains a total of 360840 time steps, and 164 complete
seasons.  The TCWV field contains a total of 564 GB of data.

The scripts contained in this repo were used to process the above dataset using
164 cores on 169 GPUs on 43 nodes on NERSC's Cray supercomputer Perlmutter. The
run computed seasonal averages of TCWV. The run completed in 17m 54s and
generated a total of 675 MB of data.

3 scripts were used for the run.

| script name | description |
| :---- | :---- |
| [0_data_layout_ERA5.sh](0_data_layout_ERA5.sh) | Create symlinks to the data such that it appears that all the files for a single variable are co-located in a single directory |
| [1_run_planning_ERA5.sh](1_run_planning_ERA5.sh) | Scans the dataset. The output is used to determine the number of Cori nodes needed for the calculation of seasonal averages of TCWV. |
| [2_seasonal_average_ERA5.sh](2_seasonal_average_ERA5.sh) | Makes the run computing seasonal averages of TCWV. |

These can be used as a template for making other similar runs. The run size was
determined by the number of seasons the input data spans. 4 seasons in each of
43 years which leads to using 169 GPUs to process the 169 seasons. One will
need to modify the paths in the scripts to point to a TECA install. One may or may
not need to reorganize the data as shown in this example.
