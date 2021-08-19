#!/bin/bash
#SBATCH -q regular
#SBATCH -N 822
#SBATCH -C knl
#SBATCH -t 01:00:00
#SBATCH -A m636

module switch PrgEnv-intel/6.0.5 PrgEnv-gnu
module use /global/cscratch1/sd/loring/teca_testing/installs/develop-53291486-deps/modulefiles/
module load teca
source /global/cscratch1/sd/loring/teca_testing/teca_tcpypi_env/bin/activate

export PATH=/global/cscratch1/sd/loring/teca_testing/TECA/bin/bin/:$PATH
export LD_LIBRARY_PATH=/global/cscratch1/sd/loring/teca_testing/TECA/bin/lib/:$LD_LIBRARY_PATH
export PYTHONPATH=/global/cscratch1/sd/loring/teca_testing/TECA/bin/lib/:$PYTHONPATH

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

