#!/bin/bash
#SBATCH -C knl
#SBATCH -N 17
#SBATCH -q debug
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -J 1_run_planning

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
module use /global/common/software/m1517/teca/develop/modulefiles
module load teca

# print the commands as they execute, and error out if any one command fails
set -e
set -x

# run the probe to determine number size of the dataset
time srun -N 17 -n 1024 \
    teca_metadata_probe --input_file ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt.mcf

# A total of 94964 steps available. Using the gregorian calendar. Times are specified
# in units of days since 1950-1-1 00:00:00. The available times range from 1950-1-1
# 0:0:0 (0) to 2014-12-31 18:0:0 (23740.8).
#
# Mesh dimension: 3D
# Mesh coordinates: lon, lat, plev
# Mesh extents: 0, 719, 0, 360, 0, 6
# Mesh bounds: 0, 359.5, -90, 90, 92500, 5000
#
# 8 data arrays available
#
#   Id   Name    Type         Centering     Dimensions                Shape
# ------------------------------------------------------------------------------------------
#   1    lat     NC_DOUBLE    point 1D      [lat]                     [361]
#   2    lon     NC_DOUBLE    point 1D      [lon]                     [720]
#   3    plev    NC_DOUBLE    point 1D      [plev]                    [7]
#   4    ta      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]
#   5    time    NC_DOUBLE    point 0D      [time]                    [94964]
#   6    ua      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]
#   7    va      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]
#   8    zg      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]

