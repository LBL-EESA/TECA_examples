#!/bin/bash
#SBATCH -C knl
#SBATCH -N 10
#SBATCH -q debug
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -J 1_run_planning

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
#module use /global/common/software/m1517/teca/cori/develop/modulefiles
#module load teca

module use /global/cscratch1/sd/loring/teca_testing/installs/develop-66481196-deps/modulefiles/
module load teca

wd=/global/cscratch1/sd/loring/teca_testing/TECA/bin/
export LD_LIBRARY_PATH=${wd}/lib:$LD_LIBRARY_PATH
export PYTHONPATH=${wd}/lib:$PYTHONPATH
export PATH=${wd}/bin:$PATH

in_dir=HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt/ivt_all/

# run the probe to determine number size of the dataset
time srun -N 10 -n 1024 \
    teca_metadata_probe --input_regex ${in_dir}/ivt_'.*\.nc$'
