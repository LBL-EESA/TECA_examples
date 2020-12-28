#!/bin/bash
#SBATCH -C knl
#SBATCH -N 1484
#SBATCH -q regular
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -J 2_CASCADE_BARD_AR_detect

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
module use /global/cscratch1/sd/loring/teca_testing/installs/develop/modulefiles
module load teca

# print the commands aas the execute, and error out if any one command fails
set -e
set -x

# make a directory for the output files
out_dir=HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt/CASCADE_BARD_all_prof
mkdir -p ${out_dir}

# enable profiling
export PROFILER_ENABLE=3
export PROFILER_LOG_FILE=cascade_bard_time_${SLURM_JOB_ID}.csv
export MEMPROF_LOG_FILE=cascade_bard_mem_${SLURM_JOB_ID}.csv
export MEMPROF_INTERVAL=2

# do the ar detections. change -N and -n to match the rus size.
# the run size is determened by the number of input time steps selected by
# the input file. Note that CASCADE BARD relies on trheading for performance
# and spreading the MPI ranks out such that each has a number of threads is
# advised.
time srun -N 1484 -n 23744 teca_bayesian_ar_detect \
    --input_file ./HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt.mcf \
    --specific_humidity hus --wind_u ua --wind_v va --ivt_u ivt_u --ivt_v ivt_v --ivt ivt \
    --compute_ivt --write_ivt --write_ivt_magnitude --steps_per_file 128 \
    --output_file ${out_dir}/CASCADE_BARD_AR_%t%.nc

