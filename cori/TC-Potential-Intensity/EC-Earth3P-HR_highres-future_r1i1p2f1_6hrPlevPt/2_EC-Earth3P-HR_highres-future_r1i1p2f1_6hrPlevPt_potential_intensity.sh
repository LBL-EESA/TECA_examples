#!/bin/bash
#SBATCH -q regular
#SBATCH -N 822
#SBATCH -C knl
#SBATCH -t 01:00:00
#SBATCH -A m1517

module swap PrgEnv-intel PrgEnv-gnu
module use /global/common/software/m1517/teca/cori/develop/modulefiles
module load teca

set -x

output_dir=data/EC-Earth3P-HR_highres-future_r1i1p2f1_6hrPlevPt_ym
rm -rf ${output_dir}/
mkdir -p ${output_dir}

time srun -n 13149  -N 822 teca_potential_intensity \
    --input_file EC-Earth3P-HR_highres-future_r1i1p2f1_6hrPlevPt.mcf \
    --psl_variable psl --sst_variable ts --air_temperature_variable ta  \
    --specific_humidity_variable hus --file_layout yearly \
    --output_file ${output_dir}/EC-Earth3P-HR_highres-future_r1i1p2f1_6hrPlevPt_TCPI_%t%.nc \
    --land_mask_variable LANDFRAC \
    --land_mask_file /global/cscratch1/sd/loring/teca_testing/topography/USGS_gtopo30_0.23x0.31_remap_c061107.nc \
    --verbose 1

