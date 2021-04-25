#!/bin/bash
#SBATCH -C knl
#SBATCH -N 1024
#SBATCH -q regular
#SBATCH -t 04:00:00
#SBATCH -A m1517
#SBATCH -J 2_slice_data

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
module use /global/common/software/m1517/teca/develop/modulefiles
module load teca

# A total of 94964 steps available. Using the gregorian calendar. Times are specified
# in units of days since 1950-1-1 00:00:00. The available times range from 1950-1-1
# 0:0:0 (0) to 2014-12-31 18:0:0 (23740.8).
# 
# Mesh dimension: 3D
# Mesh coordinates: lon, lat, plev
# Mesh extents: 0, 719, 0, 360, 0, 6
# Mesh bounds: 0, 359.5, -90, 90, 92500, 5000
# 
# 8 data arrays available
# 
#   Id   Name    Type         Centering     Dimensions                Shape
# ------------------------------------------------------------------------------------------
#   1    lat     NC_DOUBLE    point 1D      [lat]                     [361]
#   2    lon     NC_DOUBLE    point 1D      [lon]                     [720]
#   3    plev    NC_DOUBLE    point 1D      [plev]                    [7]
#   4    ta      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]
#   5    time    NC_DOUBLE    point 0D      [time]                    [94964]
#   6    ua      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]
#   7    va      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]
#   8    zg      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]


# for the gfdl tc detector we need:
# Sea level pressure
# Surface wind vector
# 850 mb wind vector
# 500 mb temperature
# 200 mb temperature
# 1000 mb height
# 200 mb height


set -x

NN=1024
let nn=${NN}*4

data_root_out=ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt
mkdir ${data_root_out}

data_root_in=/global/cfs/cdirs/m3522/cmip6/CMIP6_hrmcol/HighResMIP/CMIP6/HighResMIP/ECMWF/ECMWF-IFS-HR/highresSST-present/r1i1p1f1/6hrPlevPt
regex_in=6hrPlevPt_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_gr_'.*\.nc$'

var_in=(ua va ta ta zg zg)
plev_mb=(850 850 200 500 200 924)

let n=${#var_in[@]}-1

for i in `seq 0 $n`
do
    let plev_pa=${plev_mb[${i}]}*100
    var_out=${var_in[${i}]}${plev_mb[${i}]}

    echo "====================================================="
    echo "slicing ${var_in[${i}]} at ${plev_pa} into ${var_out}"
    echo "====================================================="

    rm -rf "${data_root_out}/${var_out}"
    mkdir -p "${data_root_out}/${var_out}"

    time srun -n ${nn} -N ${NN}                                                                                             \
        teca_cf_restripe                                                                                                    \
        --input_regex "${data_root_in}/${var_in[${i}]}/gr/v20170915/${var_in[${i}]}_${regex_in}"                            \
        --z_axis_variable plev --regrid --dims 720 361 1 --bounds 0 359.5 -90 90 ${plev_pa} ${plev_pa}                      \
        --rename --original_name ${var_in[${i}]} --new_name ${var_out}                                                      \
        --output_file "${data_root_out}/${var_out}/${var_out}_6hrPlevPt_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_gr_%t%.nc" \
        --point_arrays ${var_out} --file_layout monthly
done
