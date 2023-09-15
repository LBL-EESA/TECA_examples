#!/bin/bash
set -x

TECA=/pscratch/sd/l/loring/teca_testing/TECA/build_gpu_r
export PATH=${TECA}/bin:${TECA}/bin/test:$PATH
export LD_LIBRARY_PATH=${TECA}/lib:$LD_LIBRARY_PATH
#export CUDA_VISIBLE_DEVICES=1

nvidia-cuda-mps-control -d

module load darshan/3.4.0-hdf5

# directory on scratch
input_dir=profile_input_mpi
output_dir=profile_output
file_base=e5_oper_an_sfc_128_137_tcwv_ll025sc_


r_bind=1
r_strm=8
r_prop=0
r_spreq=1
r_rpd=2


w_nr=8
for j in `seq 1 2`
do

#w_nt=64/w_nr
#w_nt=$(( w_nt > 2 ? 2 : w_nt ))

w_nt=-2
w_strm=1
w_bind=1
w_rpd=100

#r_nt=64/w_nr
#r_nt=$(( r_nt > 4 ? 4 : r_nt ))
r_nt=-4

echo "======== w_nr=${w_nr}  w_nt=${w_nt}  r_nt=${r_nt}   r_bind=${r_bind}  r_spreq=${r_spreq}  r_strm=${r_strm} ========"

time srun --export=ALL,LD_PRELOAD=$DARSHAN_BASE_DIR/lib/libdarshan.so -N 1 -n ${w_nr} test_cpp_temporal_reduction_io \
    ${input_dir}/${file_base}'.*\.nc$' \
    longitude latitude . time TCWV 0 -1 \
    ${r_nt} ${r_nt} ${r_rpd} ${r_strm} ${r_bind} ${r_prop} monthly average ${r_spreq} \
    ${output_dir}/${file_base}_mon_avg_cpu_mpi_%t%.nc monthly \
    ${w_nt} ${w_nt} ${w_rpd} ${w_strm} ${w_bind}

let w_nr=2*w_nr
done

echo quit | nvidia-cuda-mps-control

