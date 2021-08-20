#!/bin/bash
#SBATCH -q regular
#SBATCH -N 822
#SBATCH -C knl
#SBATCH -t 01:00:00
#SBATCH -A m636

module swap PrgEnv-intel PrgEnv-gnu
module use /global/common/software/m1517/teca/develop/modulefiles
module load teca

set -x

output_dir=data/EC-Earth3P-HR_highres-future_r1i1p2f1_6hrPlevPt_y
rm -rf ${output_dir}/
mkdir -p ${output_dir}

time srun -n 13149  -N 822 teca_potential_intensity \
    --input_file EC-Earth3P-HR_highres-future_r1i1p2f1_6hrPlevPt.mcf \
    --psl_variable psl --sst_variable ts --air_temperature_variable ta --specific_humidity_variable hus \
    --output_file ${output_dir}/EC-Earth3P-HR_highres-future_r1i1p2f1_6hrPlevPt_TCPI_%t%.nc \
    --file_layout yearly --validate_spatial_coordinates 0 \
    --verbose 1

