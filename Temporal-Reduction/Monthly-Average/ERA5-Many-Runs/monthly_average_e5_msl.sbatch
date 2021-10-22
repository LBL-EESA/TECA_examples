#!/bin/bash
#SBATCH -N 54
#SBATCH -C knl
#SBATCH -q regular
#SBATCH -t 01:00:00
#SBATCH -A m3875

module use /global/common/software/m1517/teca/develop/modulefiles/
module switch PrgEnv-intel PrgEnv-gnu
module load teca

set -x

rm -rf /global/cscratch1/sd/loring/teca_testing/era5_bill/e5_msl/out
mkdir -p /global/cscratch1/sd/loring/teca_testing/era5_bill/e5_msl/out

time srun -n 852 -N 54 teca_temporal_reduction \
    --x_axis_variable longitude --y_axis_variable latitude \
    --input_regex '/global/cscratch1/sd/loring/teca_testing/era5_bill/e5_msl/in/^e5_.*msl.*\.nc$' \
    --interval monthly --operator average --point_arrays MSL \
    --output_file /global/cscratch1/sd/loring/teca_testing/era5_bill/e5_msl/out/e5_oper.an.sfc.128_151_msl.ll025sc_%t%.nc \
    --file_layout yearly \
    --verbose 0
