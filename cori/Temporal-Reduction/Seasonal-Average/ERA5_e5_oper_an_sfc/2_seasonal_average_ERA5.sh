#!/bin/bash
#SBATCH -C knl
#SBATCH -N 164
#SBATCH -q premium
#SBATCH -t 05:00:00
#SBATCH -A m1517
#SBATCH -J 2_seasonal_average_ERA5

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
module use /global/common/software/m1517/teca/develop/modulefiles
module load teca

# print the commands as they execute, and error out if any one command fails
set -e
set -x

# directory with symlinks to the files
data_dir=CMIP6_ERA5_e5_oper_an_sfc

# make a directory for the output files
out_dir=CMIP6_ERA5_e5_oper_an_sfc_seasonal_avg
mkdir -p ${out_dir}

# compute the daily average. change -N and -n to match the run size.
# the run size is determened by the number of output time steps. here the
# input is 41 years of 1 hourly data, the output is seasonal, with 164 seasons.
time srun -N 164 -n 164 \
    teca_temporal_reduction \
        --n_threads 4 --verbose 1 --input_regex ${data_dir}/'.*\.nc$' \
        --x_axis_variable longitude --y_axis_variable latitude \
        --interval seasonal --operator average --point_arrays TCWV \
        --output_file ${out_dir}/e5_oper_an_sfc_128_137_tcwv_ll025sc_seasonal_avg_%t%.nc \
        --file_layout number_of_steps --steps_per_file 1
