#!/bin/bash
#SBATCH -N 2
#SBATCH -C gpu
#SBATCH -G 8
#SBATCH -q debug
#SBATCH -t 00:30:00
#SBATCH -A m1517_g
#SBATCH -J 1_run_planning_ERA5

# load gcc
module load PrgEnv-gnu
module load cudatoolkit
module load cpe-cuda

# bring a TECA install into your environment.
module use /global/common/software/m1517/perlmutter/teca/develop/modulefiles/
module load teca

# print the commands as they execute, and error out if any one command fails
set -e
set -x

# run the probe to determine number size of the dataset
time srun -n 64 teca_metadata_probe \
    --input_regex ./CMIP6_ERA5_e5_oper_an_sfc/'.*\.nc$' \
    --x_axis_variable longitude --y_axis_variable latitude

# STATUS: The y-axis will be transformed to be in ascending order.
#
# A total of 372528 steps available in 510 files. Using the gregorian calendar.
# Times are specified in units of hours since 1900-01-01 00:00:00. The available
# times range from 1979-1-1 0:0:0 (692496) to 2021-6-30 22:59:60 (1.06502e+06).
#
# Mesh dimension: 2D
# Mesh coordinates: longitude, latitude
# Mesh extents: 0, 1439, 0, 720
# Mesh bounds: 0, 359.75, -90, 90
#
# 5 data arrays available
#
#   Id   Name         Type         Centering     Dimensions                     Shape
# ---------------------------------------------------------------------------------------------------
#   1    TCWV         NC_FLOAT     point 2D      [time, latitude, longitude]    [372528, 721, 1440]
#   2    latitude     NC_DOUBLE    point 1D      [latitude]                     [721]
#   3    longitude    NC_DOUBLE    point 1D      [longitude]                    [1440]
#   4    time         NC_INT       point 0D      [time]                         [372528]
#   5    utc_date     NC_INT       point 0D      [time]                         [372528]
#
#
# real	0m10.806s
# user	0m0.023s
# sys	0m0.010s


