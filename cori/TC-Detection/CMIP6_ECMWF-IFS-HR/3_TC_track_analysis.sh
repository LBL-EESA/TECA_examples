#!/bin/bash
#SBATCH -A m1517
#SBATCH -C knl
#SBATCH -t 00:30:00
#SBATCH -q debug
#SBATCH -N 10
#SBATCH -J 3_TC_track_analysis

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
module use /global/common/software/m1517/teca/develop/modulefiles
module load teca

# print the commands aas the execute, and error out if any one command fails
set -e
set -x

wind_data=./ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt_2D.mcf
track_file=tracks_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt

# run the wind radii calculation
# 3992 tracks
time srun -N 10 -n 640 \
    teca_tc_wind_radii --input_file ${wind_data} --wind_u_var uas --wind_v_var vas \
        --track_file ${track_file}.bin --track_file_out wind_${track_file}.bin

# convert the tracks file to CSV
time teca_convert_table wind_${track_file}.bin wind_${track_file}.csv

# compute track stats
mkdir -p stats
rm -rf stats/*

time teca_tc_stats ${track_file}.bin \
        stats/ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt

# compute wind radii stats
time teca_tc_wind_radii_stats wind_${track_file}.bin stats/wind_${track_file}

# make plots of the tracks
mkdir -p tracks
rm -rf tracks/*

time srun -N 10 -n 128 teca_tc_trajectory_scalars --texture earthmap4k.png \
        wind_${track_file}.bin ./tracks/wind_${track_file}
