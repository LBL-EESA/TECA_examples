#!/bin/bash
#SBATCH -C knl
#SBATCH -N 12
#SBATCH -q debug
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -J 1_run_planning

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
# change the following path to point to your TECA install
module use /global/common/software/m1517/teca/develop/modulefiles
module load teca

# print the commands as they execute, and error out if any one command fails
set -e
set -x

# run the probe to determine number size of the dataset
time srun -N 12 -n 780 teca_metadata_probe --z_axis_variable plev \
        --input_file CMIP6_MOHC_HadGEM3-GC31-HM_highresSST-present_r1i2p1f1_E3hrPt.mcf
