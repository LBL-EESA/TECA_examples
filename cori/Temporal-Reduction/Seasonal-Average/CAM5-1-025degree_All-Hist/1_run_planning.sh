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
module use /global/common/software/m1517/teca/cori/develop/modulefiles
module load teca

data_dir=/global/cscratch1/sd/mwehner/machine_learning_climate_data/All-Hist/CAM5-1-0.25degree_All-Hist_est1_v3_run1/h2

# run the probe to display variables, number of time steps, and time range
time srun -N 17 -n 1024 \
    ./bin/teca_metadata_probe --input_regex=${data_dir}/'.*\.nc$'

