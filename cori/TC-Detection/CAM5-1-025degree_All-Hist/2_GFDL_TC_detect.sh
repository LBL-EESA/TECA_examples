#!/bin/bash
#SBATCH -N 913
#SBATCH -C knl
#SBATCH -q regular
#SBATCH -t 01:00:00
#SBATCH -A m1517
#SBATCH -J 2_GFDL_TC_detect

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
module use /global/common/software/m1517/teca/cori/develop/modulefiles
module load teca

# print the commands as they execute, and error out if any one command fails
set -e
set -x

data_dir=/global/cscratch1/sd/mwehner/machine_learning_climate_data/All-Hist/CAM5-1-0.25degree_All-Hist_est1_v3_run1/h2

# run the GFDL TC detector
time srun -N 913 -n 58400 \
    teca_tc_detect --input_regex ${data_dir}/'.*\.nc$'  \
        --candidate_file candidates_CAM5-1-025degree_All-Hist_est1_v3_run1_h2.bin \
        --track_file tracks_CAM5-1-025degree_All-Hist_est1_v3_run1_h2.bin

