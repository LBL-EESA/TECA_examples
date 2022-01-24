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
    teca_metadata_probe --input_file HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt.mcf
