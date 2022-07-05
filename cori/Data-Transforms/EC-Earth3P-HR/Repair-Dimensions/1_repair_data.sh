#!/bin/bash
#SBATCH -q regular
#SBATCH -N 46
#SBATCH -C knl
#SBATCH -t 03:00:00
#SBATCH -A m1517

module switch PrgEnv-intel PrgEnv-gnu
module use /global/common/software/m1517/teca/cori/develop/modulefiles/
module load teca

#
# This example repairs the EC-Earth-3P data
#
# 1. In all but 3 of the files hus is dimensioned with integer indices i,j. we
#    use TECA to transform these i,j indices into lon, lat coordinates
#
# 2. In 3 of the files hus is dimensioned with lon, lat values. in the files
#    with i,j indices there are additional arrays latitude and longitude which
#    changes the structure of the file. This is an issue for TECA because it
#    assumes that all files in the dataset have the same internal structure
#    at the NetCDF level.
#
# in this dataset each file stores a year's worth of data. we loop over the files
# determine the number of time steps from which we can set the run size. we check
# for the i, j dime3nsions on hus and if found we apply a transform to lon, lat
# dimensions. this is done via the MCF reader, and the MCF file is needed.
# When the i, j indices are not present we rewrite the file to be sure that
# all the files have the same structure.
#
# each file had 1460 or 1461 steps. running at that concurency took
# approximately 2 min per file on Cori KNL.


set -x

output_dir=./repaired_data
rm -rf ${output_dir}
mkdir -p ${output_dir}

data_dir=/global/cfs/cdirs/m3522/cmip6/CMIP6_hrmcol/HighResMIP/CMIP6/HighResMIP/EC-Earth-Consortium/EC-Earth3P-HR/highresSST-present/r3i1p1f1/6hrPlevPt/hus/gr/v20190509/
file_base=hus_6hrPlevPt_EC-Earth3P-HR_highresSST-present_r3i1p1f1_gr_

for year in `seq 1950 2014`;
do

echo "PROCESSING ${year}"

regex=${data_dir}/${file_base}${year}'.*\.nc$'

n_proc=`ncdump -h ${data_dir}/${file_base}${year}*.nc | grep 'time = '| cut -d'(' -f2 | cut -d' ' -f1`

dim_str=`ncdump -h ${data_dir}/${file_base}${year}*.nc | grep 'hus('`
if [[ ${dim_str} == *"j, i"* ]]
then

echo "TRANSFORMING COORDINATES ${year} ${dim_str}"

mcf_file=${file_base}${year}.mcf
cat <<mcf >${mcf_file}
data_root = /global/cfs/cdirs/m3522/cmip6/CMIP6_hrmcol/HighResMIP/CMIP6/HighResMIP/EC-Earth-Consortium/EC-Earth3P-HR/highresSST-present/r3i1p1f1/6hrPlevPt
regex = 6hrPlevPt_EC-Earth3P-HR_highresSST-present_r3i1p1f1_gr_${year}.*\.nc$
[cf_reader]
variables = hus, latitude, longitude
regex = %data_root%/hus/gr/v20190509/hus_%regex%
x_axis_variable = i
y_axis_variable = j
z_axis_variable = plev
target_bounds = 0, 359.648438, -89.7311478, 89.7311478, 1, 0
target_x_axis_variable = lon
target_x_axis_units = degrees_east
target_y_axis_variable = lat
target_y_axis_units = degrees_north
provides_time
provides_geometry
mcf

time srun -n ${n_proc} teca_cf_restripe \
    --input_file ${mcf_file} \
    --output_file ${output_dir}/${file_base}%t%.nc \
    --point_arrays hus \
    --file_layout yearly

#rm ${mc_file}

elif [[ ${dim_str} == *"lat, lon"* ]]
then

echo "COPYING FILE ${year} ${dim_str}"

time srun -n ${n_proc} teca_cf_restripe \
    --input_regex ${regex} \
    --output_file ${output_dir}/${file_base}%t%.nc \
    --point_arrays hus \
    --z_axis_variable plev \
    --file_layout yearly

else

echo "ERROR! ${year} ${dim_str}"

fi

done
