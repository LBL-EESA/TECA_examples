#!/bin/bash
#SBATCH -C knl
#SBATCH -N 1484
#SBATCH -q regular
#SBATCH -t 00:45:00
#SBATCH -A m1517
#SBATCH -J 2_deeplab_AR_detect

# bring a TECA install into your environment
module use /global/cscratch1/sd/loring/teca_testing/installs/develop/modulefiles
module load teca

# print the commands aas the execute, and error out if any one command fails
set -e
set -x

# tell explicitly how many cores to use
export OMP_NUM_THREADS=4

pytorch_model=/global/cscratch1/sd/loring/teca_testing/TECA_data/cascade_deeplab_IVT.pt

# make a directory for the output files
out_dir=HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt/deeplab_all_prof
mkdir -p ${out_dir}

# do the ar detections. change -N and -n to match the rus size.
# the run size is determened by the number of input time steps selected by
# the input file. Note that CASCADE BARD relies on trheading for performance
# and spreading the MPI ranks out such that each has a number of threads is
# advised.
time srun -N 1484 -n 23744 teca_deeplab_ar_detect \
    --verbose --pytorch_model ${pytorch_model} --n_threads 4 \
    --input_file ./HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt.mcf \
    --compute_ivt --wind_u ua --wind_v va --specific_humidity hus --write_ivt --write_ivt_magnitude \
    --output_file ${out_dir}/deeplab_AR_%t%.nc --steps_per_file 128

