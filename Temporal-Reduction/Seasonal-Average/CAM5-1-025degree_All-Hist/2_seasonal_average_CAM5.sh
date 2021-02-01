#!/bin/bash
#SBATCH -C knl
#SBATCH -N 80
#SBATCH -q regular
#SBATCH -t 02:00:00
#SBATCH -A m1517
#SBATCH -J 2_seasonal_average

module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment
# change the following paths to point to your TECA install
module use /global/common/software/m1517/teca/stable
module load teca

# print the commands as they execute, and error out if any one command fails
set -e
set -x

# configure HDF5 file locking if on Cori (CFS)community file system
# This is not needed on Cori Lustre scratch file system
#export HDF5_USE_FILE_LOCKING=FALSE

# prevents an abort when import'ing numpy on KNL
export OPENBLAS_NUM_THREADS=1

# make a directory for the output files
data_dir=/global/cscratch1/sd/mwehner/machine_learning_climate_data/All-Hist/CAM5-1-0.25degree_All-Hist_est1_v3_run1/h2

out_dir=CAM5-1-025degree_All-Hist_est1_v3_run1_seasonal_avg
mkdir -p ${out_dir}

# compute the daily average. change -N and -n to match the rus size.
# the run size is determened by the number of output time steps. here the
# input is 20 years of 3 hourly data, the output is seasonal, with 80 seasons.
time srun -N 80 -n 80 \
    teca_temporal_reduction \
        --n_threads 2 --verbose 1 --input_regex ${data_dir}/'.*\.nc$' \
        --interval seasonal --operator average --point_arrays TS TMQ --ignore_fill_value \
        --output_file ${out_dir}/CAM5-1-025degree_All-Hist_est1_v3_seasonal_avg_%t%.nc \
        --steps_per_file 4


