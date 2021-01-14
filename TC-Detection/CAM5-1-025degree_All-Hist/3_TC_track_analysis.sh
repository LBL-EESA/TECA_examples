#!/bin/bash
#SBATCH -A m1517
#SBATCH -C knl
#SBATCH -t 00:30:00
#SBATCH -q debug
#SBATCH -N 22
#SBATCH -J 3_TC_track_analysis

# load gcc
module swap PrgEnv-intel PrgEnv-gnu

# bring a TECA install into your environment.
module use /project/projectdirs/m1517/TECA/latest/modulefiles
module load teca

# print the commands aas the execute, and error out if any one command fails
set -e
set -x

data_dir=/global/cscratch1/sd/mwehner/machine_learning_climate_data/All-Hist/CAM5-1-0.25degree_All-Hist_est1_v3_run1/h2

# run the wind radii calculation
# note there are 7300 files in this dataset, hence large core count
time srun -N 22 -n 1448 \
    teca_tc_wind_radii --input_regex ${data_dir}/'^CAM5.*\.nc$' \
        --track_file ./CAM5-1-025degree_All-Hist_est1_v3_run1_h2_tracks.bin \
        --track_file_out ./wind_tracks_CAM5-1-2_025degree_All-Hist_est1_v3_run1.bin

# convert the tracks file to CSV
time srun -N 1 -n 1 \
    teca_convert_table \
        ./wind_tracks_CAM5-1-2_025degree_All-Hist_est1_v3_run1.bin \
        ./wind_tracks_CAM5-1-2_025degree_All-Hist_est1_v3_run1.csv

# compute track stats
mkdir -p stats
rm -rf stats/*

time srun -N 1 -n 1  \
    teca_tc_stats \
        ./CAM5-1-025degree_All-Hist_est1_v3_run1_h2_tracks.bin \
        stats/CAM5-1-2_025degree_All-Hist_est1_v3_run1

# compute wind radii stats
time srun -n 1 \
    teca_tc_wind_radii_stats \
        wind_tracks_CAM5-1-2_025degree_All-Hist_est1_v3_run1.bin \
        stats/wind_CAM5-1-2_025degree_All-Hist_est1_v3_run1

# make plots of the tracks
mkdir -p tracks
rm -rf tracks/*

time srun -N 22 -n 512 \
    teca_tc_trajectory_scalars --texture earthmap4k.png \
        ./wind_tracks_CAM5-1-2_025degree_All-Hist_est1_v3_run1.bin \
        ./tracks/wind_tracks_CAM5-1-2_025degree_All-Hist_est1_v3_run1
