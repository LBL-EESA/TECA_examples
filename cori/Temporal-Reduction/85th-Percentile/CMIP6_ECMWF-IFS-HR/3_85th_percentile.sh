#!/bin/bash
#SBATCH -C knl
#SBATCH -N 259
#SBATCH -q regular
#SBATCH -t 01:00:00
#SBATCH -A m636
#SBATCH -J 4_85th_percentile

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
module use /global/common/software/m1517/teca/cori/develop/modulefiles
module load teca


# print the commands as they execute, and error out if any one command fails
set -e
set -x

# make a directory for the output files
out_dir=HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt/ivt_all_85th_percentile
mkdir -p ${out_dir}

in_dir=HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt/ivt_all/

# compute the daily average. change -N and -n to match the run size.
time srun -N 259 -n 4144 \
    teca_temporal_reduction \
        --verbose 1 --input_regex ${in_dir}/ivt_'.*\.nc$' \
        --interval seasonal --operator 85th_percentile --spatial_partitioning \
        --point_arrays ivt --output_file ${out_dir}/ivt_85th_percentile_%t%.nc \
        --file_layout yearly --partition_x --ignore_fill_value
