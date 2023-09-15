#!/bin/bash

set -x

TECA=/pscratch/sd/l/loring/teca_testing/TECA/build_gpu_r
export PATH=${TECA}/bin:${TECA}/bin/test:$PATH
export LD_LIBRARY_PATH=${TECA}/lib:$LD_LIBRARY_PATH

# directory on scratch
input_dir=profile_input_threads_cfs
output_dir=profile_output
file_base=e5
#e5_oper_an_sfc_128_137_tcwv_ll025sc_

r_strm=1
r_bind=1
r_prop=0

w_strm=1
w_bind=1

w_nt=1
r_nt=1
for j in `seq 1 1`
do

r_spreq=1
for k in `seq 1 10`
do

echo "======== w_nt=${w_nt}  w_strm=${w_strm} w_bind=$w_bind} r_nt=${r_nt}   r_bind=${r_bind}  r_spreq=${r_spreq}  ========"

time test_cpp_temporal_reduction_io \
    ${input_dir}/${file_base}'.*\.nc$' \
    longitude latitude . time TCWV 0 -1 \
    ${r_nt} ${r_nt} ${r_nt} ${r_strm} ${r_bind} ${r_prop} monthly average ${r_spreq} \
    ${output_dir}/${file_base}_mon_avg_gpu_spreq_%t%.nc monthly \
    ${w_nt} ${w_nt} ${w_nt} ${w_strm} ${w_bind}

let r_spreq=2*r_spreq
done

let r_nt=2*r_nt
let w_nt=2*w_nt
done
