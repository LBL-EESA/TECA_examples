#!/bin/bash
#SBATCH -C knl
#SBATCH -N 1484
#SBATCH -q regular
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -J 2_IVT_calculation

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
module use /global/common/software/m1517/teca/stable
module load teca

# print the commands aas the execute, and error out if any one command fails
set -e
set -x

# make a directory for the output files
out_dir=HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt/ivt_all
mkdir -p ${out_dir}

# do the IVT calcllation. you must change -N and -n to match the rus size.
# the run size is determened by the number of input time steps selected by
# the input file.
time srun -N 1484 -n 23744 \
    teca_integrated_vapor_transport \
        --input_file ./HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt.mcf \
        --specific_humidity hus --wind_u ua --wind_v va --ivt_u ivt_u --ivt_v ivt_v --ivt ivt \
        --write_ivt 1 --write_ivt_magnitude 1 --steps_per_file 128 \
        --output_file ${out_dir}/ivt_%t%.nc
