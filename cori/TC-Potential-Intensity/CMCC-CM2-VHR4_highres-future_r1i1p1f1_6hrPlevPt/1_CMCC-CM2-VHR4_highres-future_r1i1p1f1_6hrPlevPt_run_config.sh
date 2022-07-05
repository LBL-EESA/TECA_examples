#!/bin/bash
#SBATCH -q debug
#SBATCH -N 32
#SBATCH -C knl
#SBATCH -t 00:30:00
#SBATCH -A m1517

module swap PrgEnv-intel PrgEnv-gnu
module use /global/common/software/m1517/teca/cori/develop/modulefiles
module load teca

time srun -n 128 -N 32 teca_metadata_probe \
    --input_file CMCC-CM2-VHR4_highres-future_r1i1p1f1_6hrPlevPt.mcf

# A total of 52560 steps available. Using the 365_day calendar. Times are specified
# in units of days since 2015-01-01 00:00:00. The available times range from
# 2015-1-1 0:0:0 (0) to 2050-12-31 18:0:0 (13139.8).
#
# Mesh dimension: 3D
# Mesh coordinates: lon, lat, plev
# Mesh extents: 0, 1151, 0, 767, 0, 6
# Mesh bounds: 0, 359.688, -90, 90, 92500, 5000
#
# 8 data arrays available
#
#   Id   Name    Type         Centering     Dimensions                Shape
# -------------------------------------------------------------------------------------------
#   1    hus     NC_FLOAT     point 3D      [time, plev, lat, lon]    [52560, 7, 768, 1152]
#   2    lat     NC_DOUBLE    point 1D      [lat]                     [768]
#   3    lon     NC_DOUBLE    point 1D      [lon]                     [1152]
#   4    plev    NC_DOUBLE    point 1D      [plev]                    [7]
#   5    psl     NC_FLOAT     point 2D      [time, lat, lon]          [52560, 768, 1152]
#   6    ta      NC_FLOAT     point 3D      [time, plev, lat, lon]    [52560, 7, 768, 1152]
#   7    time    NC_DOUBLE    point 0D      [time]                    [52560]
#   8    ts      NC_FLOAT     point 2D      [time, lat, lon]          [52560, 768, 1152]
#
#
# real	0m23.110s
# user	0m0.430s
# sys	0m0.329s
