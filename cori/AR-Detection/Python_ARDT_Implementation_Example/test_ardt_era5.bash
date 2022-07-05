#!/bin/bash
#SBATCH -N 4
#SBATCH -C haswell
#SBATCH -q regular
#SBATCH -t 00:05:00

# load TECA
module swap PrgEnv-intel PrgEnv-gnu
module use /global/common/software/m1517/teca/cori/develop/modulefiles
module load teca

# configure bash to error-out if any of the next lines errors
set -e
# configure bash to echo commands
set -x

# run the TECA example on one year of ERA 20CR output
srun -n 128 ./teca_ardt_example_detect \
    --input_regex "/global/project/projectdirs/m1517/cascade/external_datasets/era_20cr/ivt/e20c\.oper\.an\.sfc\.3hr\.162_IVT\.regn80sc\.2006010100_2006123121\.nc4" \
    --ivt "IVT" \
    --file_layout "yearly" \
    --output_file "test_ardt_example_%t%.nc" \
    --verbose

