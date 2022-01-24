#!/bin/bash
#SBATCH -q debug
#SBATCH -N 32
#SBATCH -C knl
#SBATCH -t 00:30:00
#SBATCH -A m1517

module swap PrgEnv-intel PrgEnv-gnu
module use /global/common/software/m1517/teca/develop/modulefiles
module load teca

time srun -n 128 -N 32 teca_metadata_probe \
    --input_file EC-Earth3P-HR_highres-future_r1i1p2f1_6hrPlevPt.mcf

#
# A total of 52596 steps available. Using the proleptic_gregorian calendar. Times
# are specified in units of hours since 1950-01-01 00:00:00. The available times
# range from 2015-1-1 0:0:0 (569784) to 2050-12-31 18:0:0 (885354).
#
# Mesh dimension: 3D
# Mesh coordinates: i, j, plev
# Mesh extents: 0, 1023, 0, 511, 0, 26
# Mesh bounds: 1, 1024, 1, 512, 100000, 10000
#
# 10 data arrays available
#
#   Id    Name         Type         Centering     Dimensions            Shape
# ----------------------------------------------------------------------------------------------
#   1     hus          NC_FLOAT     point 3D      [time, plev, j, i]    [52596, 27, 512, 1024]
#   2     i            NC_INT       point 1D      [i]                   [1024]
#   3     j            NC_INT       point 1D      [j]                   [512]
#   4     latitude     NC_FLOAT     point 2D      [j, i]                [512, 1024]
#   5     longitude    NC_FLOAT     point 2D      [j, i]                [512, 1024]
#   6     plev         NC_DOUBLE    point 1D      [plev]                [27]
#   7     psl          NC_FLOAT     point 2D      [time, lat, lon]      [52596, 512, 1024]
#   8     ta           NC_FLOAT     point 3D      [time, plev, j, i]    [52596, 27, 512, 1024]
#   9     time         NC_DOUBLE    point 0D      [time]                [52596]
#   10    ts           NC_FLOAT     point 2D      [time, lat, lon]      [52596, 512, 1024]
#

