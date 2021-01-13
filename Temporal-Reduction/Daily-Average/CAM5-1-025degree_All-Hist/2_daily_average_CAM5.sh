#!/bin/bash
#SBATCH -C knl
#SBATCH -N 73
#SBATCH -q regular
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -J 2_daily_average

module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment
# change the following paths to point to your TECA install
module use /project/projectdirs/m1517/TECA/latest/modulefiles
module load teca

# print the commands as they execute, and error out if any one command fails
set -e
set -x

# make a directory for the output files
data_dir=/global/cscratch1/sd/mwehner/machine_learning_climate_data/All-Hist/CAM5-1-0.25degree_All-Hist_est1_v3_run1/h2

out_dir=CAM5-1-025degree_All-Hist_est1_v3_run1_daily_avg
mkdir -p ${out_dir}

# compute the daily average. change -N and -n to match the rus size.
# the run size is determened by the number of output time steps. here the
# input is 3 hourly, the output is daily.
time srun -N 73 -n 146 \
    teca_temporal_reduction \
        --n_threads 2 --verbose 1 --input_regex ${data_dir}/'.*\.nc$' \
        --interval daily --operator average --point_arrays TS TMQ --ignore_fill_value \
        --output_file ${out_dir}/CAM5-1-025degree_All-Hist_est1_v3_daily_avg_%t%.nc \
        --steps_per_file 50
