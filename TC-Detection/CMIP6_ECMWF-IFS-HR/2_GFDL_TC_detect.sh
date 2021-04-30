#!/bin/bash
#SBATCH -N 371
#SBATCH -C knl
#SBATCH -q regular
#SBATCH -t 01:00:00
#SBATCH -A m1517
#SBATCH -J 2_GFDL_TC_detect

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
#module use /global/common/software/m1517/teca/develop/modulefiles
#module load teca

export PATH=/global/cscratch1/sd/loring/teca_testing/TECA/bin/bin:$PATH
export LD_LIBRARY_PATH=/global/cscratch1/sd/loring/teca_testing/TECA/bin/lib:$LD_LIBRARY_PATH
export PYTHONPATH=/global/cscratch1/sd/loring/teca_testing/TECA/bin/lib:$PYTHONPATH

# print the commands as they execute, and error out if any one command fails
#set -e
set -x

# run the GFDL TC detector
time srun -N 371 -n 23741 \
    teca_tc_detect --input_file ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt_2D.mcf \
        --sea_level_pressure psl \
        --surface_wind_u uas --surface_wind_v vas \
        --850mb_wind_u ua850 --850mb_wind_v va850 \
        --500mb_temp ta500 --200mb_temp ta200 \
        --1000mb_height zg924 --200mb_height zg200 \
        --candidate_file candidates_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt.bin \
        --track_file tracks_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt.bin

# report the number of tracks detected
#time ./number_of_tc_tracks tracks_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt.bin
