#!/bin/bash



TECA=/pscratch/sd/l/loring/teca_testing/TECA/build_cpu
export PATH=${TECA}/bin:${TECA}/bin/test:$PATH
export LD_LIBRARY_PATH=${TECA}/lib:$LD_LIBRARY_PATH


# directory on scratch
input_dir=profile_input_mpi
output_dir=profile_output
file_base=e5_oper_an_sfc_128_137_tcwv_ll025sc_


set -x

r_bind=1
r_strm=8
r_prop=0
r_spreq=1

w_nr=1
for j in `seq 1 7`
do

w_nt=64/w_nr
w_nt=$(( w_nt > 2 ? 2 : w_nt ))
w_strm=1
w_bind=1

r_nt=64/w_nr
r_nt=$(( r_nt > 4 ? 4 : r_nt ))

echo "======== w_nr=${w_nr}  w_nt=${w_nt}  r_nt=${r_nt}   r_bind=${r_bind}  r_spreq=${r_spreq}  r_strm=${r_strm} ========"

time srun -N 1 -n ${w_nr} test_cpp_temporal_reduction_io \
    ${input_dir}/${file_base}'.*\.nc$' \
    longitude latitude . time TCWV 0 -1 \
    ${r_nt} ${r_nt} ${r_nt} ${r_strm} ${r_bind} ${r_prop} monthly average ${r_spreq} \
    ${output_dir}/${file_base}_mon_avg_cpu_mpi_%t%.nc monthly \
    ${w_nt} ${w_nt} ${w_nt} ${w_strm} ${w_bind}

let w_nr=2*w_nr
done


# directory with symlinks to the files
#data_dir=CMIP6_ERA5_e5_oper_an_sfc
#regex='e5\.oper\.an\.sfc\.128_137_tcwv\.ll025sc\.20200[345].*\.nc$'

# $srun -n 4 teca_metadata_probe --input_regex ${data_dir}/${regex} --x_axis_variable longitude --y_axis_variable latitude
# STATUS: [0:140137725771776] [/pscratch/sd/l/loring/teca_testing/TECA/alg/teca_normalize_coordinates.cxx:653 5.0.0-234-g38045ce]
# STATUS: The y-axis will be transformed to be in ascending order.
#
# A total of 2208 steps available in 3 files. Using the gregorian calendar. Times
# are specified in units of hours since 1900-01-01 00:00:00. The available times
# range from 2020-3-1 0:0:0 (1.05334e+06) to 2020-5-31 22:59:60 (1.05554e+06).
# The available data contains: 1 years; 1 seasons; 3 months; 92 days;
#
# Mesh dimension: 2D
# Mesh coordinates: longitude, latitude
# Mesh extents: 0, 1439, 0, 720
# Mesh bounds: 0, 359.75, -90, 90
#
# 5 data arrays available
#
#   Id   Name         Type         Centering     Dimensions                     Shape
# -------------------------------------------------------------------------------------------------
#   1    TCWV         NC_FLOAT     point 2D      [time, latitude, longitude]    [2208, 721, 1440]
#   2    latitude     NC_DOUBLE    point 1D      [latitude]                     [721]
#   3    longitude    NC_DOUBLE    point 1D      [longitude]                    [1440]
#   4    time         NC_INT       point 0D      [time]                         [2208]
#   5    utc_date     NC_INT       point 0D      [time]                         [2208]


# $srun -n 4 teca_cf_restripe --input_regex ./CMIP6_ERA5_e5_oper_an_sfc/'e5\.oper\.an\.sfc\.128_137_tcwv\.ll025sc\.20200[345].*\.nc$' --x_axis_variable longitude --y_axis_variable latitude --output_file profile_input/e5_oper_an_sfc_128_137_tcwv_ll025sc_%t%.nc --point_arrays TCWV --file_layout monthly
#
# $srun -n 4 teca_metadata_probe --input_regex ./profile_input/e5_oper_an_sfc_128_137_tcwv_ll025sc_2020'.*\.nc$' --x_axis_variable longitude --y_axis_variable latitude
# STATUS: [0:140181069934592] [/pscratch/sd/l/loring/teca_testing/TECA/alg/teca_normalize_coordinates.cxx:653 5.0.0-234-g38045ce]
# STATUS: The y-axis will be transformed to be in ascending order.
#
# A total of 2208 steps available in 3 files. Using the gregorian calendar. Times
# are specified in units of hours since 1900-01-01 00:00:00. The available times
# range from 2020-3-1 0:0:0 (1.05334e+06) to 2020-5-31 22:59:60 (1.05554e+06).
# The available data contains: 1 years; 1 seasons; 3 months; 92 days;
#
# Mesh dimension: 2D
# Mesh coordinates: longitude, latitude
# Mesh extents: 0, 1439, 0, 720
# Mesh bounds: 0, 359.75, -90, 90
#
# 4 data arrays available
#
#   Id   Name         Type         Centering     Dimensions                     Shape
# -------------------------------------------------------------------------------------------------
#   1    TCWV         NC_FLOAT     point 2D      [time, latitude, longitude]    [2208, 721, 1440]
#   2    latitude     NC_DOUBLE    point 1D      [latitude]                     [721]
#   3    longitude    NC_DOUBLE    point 1D      [longitude]                    [1440]
#   4    time         NC_FLOAT     point 0D      [time]                         [2208]
#
#
# make a directory for the output files
#out_dir=profile_output
#mkdir -p ${out_dir}
#lfs setstripe -c 8 ${out_dir}

#srun -n 32 teca_cf_restripe --input_regex ./CMIP6_ERA5_e5_oper_an_sfc/'e5\.oper\.an\.sfc\.128_137_tcwv\.ll025sc\.2020.*\.nc$' --x_axis_variable longitude --y_axis_variable latitude --output_file profile_input/e5_oper_an_sfc_128_137_tcwv_ll025sc_%t%.nc --point_arrays TCWV --file_layout monthly --verbose
#
# $srun -n 4 teca_metadata_probe --input_regex ./profile_input/e5_oper_an_sfc_128_137_tcwv_ll025sc_2020'.*\.nc$' --x_axis_variable longitude --y_axis_variable latitude
# srun: Job 14594482 step creation temporarily disabled, retrying (Requested nodes are busy)
# srun: Step created for StepId=14594482.14
# STATUS: [0:139727137353728] [/pscratch/sd/l/loring/teca_testing/TECA/alg/teca_normalize_coordinates.cxx:653 5.0.0-241-gc80b3f1]
# STATUS: The y-axis will be transformed to be in ascending order.
#
# A total of 8784 steps available in 12 files. Using the gregorian calendar.
# Times are specified in units of hours since 1900-01-01 00:00:00. The available
# times range from 2020-1-1 0:0:0 (1.0519e+06) to 2020-12-31 22:59:60 (1.06068e+06).
# The available data contains: 1 years; 3 seasons; 12 months; 366 days;
#
# Mesh dimension: 2D
# Mesh coordinates: longitude, latitude
# Mesh extents: 0, 1439, 0, 720
# Mesh bounds: 0, 359.75, -90, 90
#
# 4 data arrays available
#
#   Id   Name         Type         Centering     Dimensions                     Shape
# -------------------------------------------------------------------------------------------------
#   1    TCWV         NC_FLOAT     point 2D      [time, latitude, longitude]    [8784, 721, 1440]
#   2    latitude     NC_DOUBLE    point 1D      [latitude]                     [721]
#   3    longitude    NC_DOUBLE    point 1D      [longitude]                    [1440]
#   4    time         NC_FLOAT     point 0D      [time]                         [8784]
#
#
