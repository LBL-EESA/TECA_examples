#!/bin/bash

#SBATCH -C knl
#SBATCH -N 32
#SBATCH -q regular
#SBATCH -t 03:00:00
#SBATCH -A nstaff
#SBATCH -J 3_high_pass_filter_cbpx

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# # bring a TECA install into your environment.
# module use /global/common/software/m1517/teca/cori/develop/modulefiles
# module load teca

module use /global/cscratch1/sd/loring/teca_testing/installs/develop-66481196-deps/modulefiles/
module load teca

wd=/global/cscratch1/sd/loring/teca_testing/TECA/bin/
export LD_LIBRARY_PATH=${wd}/lib:$LD_LIBRARY_PATH
export PYTHONPATH=${wd}/lib:$PYTHONPATH
export PATH=${wd}/bin:$PATH

# print the commands aas the execute, and error out if any one command fails
set -e
set -x

in_dir=HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt/ivt_all/

export PYTHONUNBUFFERED=True

export MPICH_MPIIO_HINTS_DISPLAY=1
export MPICH_MPIIO_HINTS="*:romio_cb_write=enable,romio_ds_write=disable"
export MPICH_MPIIO_AGGREGATOR_PLACEMENT_DISPLAY=1
export MPICH_MPIIO_STATS=1

NN=32

n=16
for i in `seq  1 3`
do

let n=n*2

let ag=$n/8


echo "===================================== 10y cb ${ag} WITHOUT partition_x ${n} nodes"

# make a directory for the output files
out_dir=HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt/ivt_all_hpf_small_cb${n}

# clean out any old results
rm -rf ${out_dir}
mkdir -p ${out_dir}
lfs setstripe -S 1048576 -c ${ag} ${out_dir}

# run the high pass filter. you must change -N and -n to match the run size.
time srun -N ${NN} -n ${n} \
    python3 -m mpi4py `which teca_spectral_filter` \
        --input_regex ${in_dir}/ivt_198'[0-9].*\.nc$' --point_arrays ivt \
        --filter_type high_pass --filter_order 0 --critical_period 5 --critical_period_units days \
        --output_file ${out_dir}/ivt_high_pass_5days_%t%.nc \
        --collective_buffer 1 --file_layout yearly --verbose 1

echo "===================================== 10y cb ${ag} partition_x ${n} nodes "

# make a directory for the output files
out_dir=HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt/ivt_all_hpf_small_cbpx${n}

# clean out any old results
rm -rf ${out_dir}
mkdir -p ${out_dir}
lfs setstripe -S 1048576 -c ${ag} ${out_dir}


# run the high pass filter. you must change -N and -n to match the run size.
time srun -N ${NN} -n ${n} \
    python3 -m mpi4py `which teca_spectral_filter` \
        --input_regex ${in_dir}/ivt_198'[0-9].*\.nc$' --point_arrays ivt \
        --filter_type high_pass --filter_order 0 --critical_period 5 --critical_period_units days \
        --partition_x --output_file ${out_dir}/ivt_high_pass_5days_%t%.nc \
        --collective_buffer 1 --file_layout yearly  --verbose 1

done
