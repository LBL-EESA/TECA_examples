#!/bin/bash
#SBATCH -C knl
#SBATCH -N 1024
#SBATCH -q regular
#SBATCH -t 01:30:00
#SBATCH -A m1517
#SBATCH -J 2_slice_data

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
module use /global/common/software/m1517/teca/cori/develop/modulefiles
module load teca

set -x

# one of daily, monthly, or yearly
interval=yearly

NN=1024
let nn=${NN}*16

data_root_out=ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt
mkdir ${data_root_out}

data_root_in=/global/cfs/cdirs/m3522/cmip6/CMIP6_hrmcol/HighResMIP/CMIP6/HighResMIP/ECMWF/ECMWF-IFS-HR/highresSST-present/r1i1p1f1/6hrPlevPt
regex_in=6hrPlevPt_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_gr_'.*\.nc$'

# slice the following variables at the specified pressure levels.
var_in=(ua va ta ta zg)
plev_mb=(850 850 200 500 200)

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
        --point_arrays ${var_out} --file_layout ${interval}
done

# extract the highest pressure level available.
echo "====================================================="
echo "extracting zg at 925 into zg925"
echo "====================================================="

rm -rf "${data_root_out}/zg925"
mkdir -p "${data_root_out}/zg925"

time srun -n ${nn} -N ${NN}                                                                                     \
    teca_cf_restripe                                                                                            \
    --input_regex "${data_root_in}/zg/gr/v20170915/zg_${regex_in}"                                              \
    --z_axis_variable plev --bounds 0 359.5 -90 90 92500 92500                                                  \
    --rename --original_name zg --new_name zg925                                                                \
    --output_file "${data_root_out}/zg925/zg925_6hrPlevPt_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_gr_%t%.nc"   \
    --point_arrays zg925 --file_layout ${interval}
