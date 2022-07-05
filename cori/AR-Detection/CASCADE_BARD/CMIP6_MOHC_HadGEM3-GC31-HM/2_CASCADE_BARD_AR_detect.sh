#!/bin/bash
#SBATCH -C knl
#SBATCH -N 2925
#SBATCH -q regular
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -J 2_CASCADE_BARD_AR_detect

# 187199 steps / 8 steps per rank = 23400 ranks
# 68 cores per node / 8 cores per rank = 8 ranks per node
# 23400 ranks / 8 ranks per node = 2925 nodes

module swap PrgEnv-intel PrgEnv-gnu

module use /global/common/software/m1517/teca/cori/develop/modulefiles
module load teca

# print the commands aas the execute, and error out if any one command fails
set -e
set -x

# make a directory for the output files
out_dir=CMIP6_MOHC_HadGEM3-GC31-HM_highresSST-present_r1i2p1f1_E3hrPt/CASCADE_BARD_all
mkdir -p ${out_dir}

# do the ar detections.
time srun -N 2925 -n 23400 teca_bayesian_ar_detect \
    --input_file CMIP6_MOHC_HadGEM3-GC31-HM_highresSST-present_r1i2p1f1_E3hrPt.mcf \
    --specific_humidity hus --wind_u ua --wind_v va --ivt_u ivt_u --ivt_v ivt_v \
    --ivt ivt --compute_ivt --write_ivt --write_ivt_magnitude \
    --output_file ${out_dir}/CASCADE_BARD_AR_%t%.nc

