## CAM5 TC detection example
This example shows the detection of TC's in a large (3TB, 7300 file) CAM5
dataset using 58400 cores on NERSC Cori (see 2_GFDL_TC_detect.sh). The run
completed in 35 minutes 4 seconds on the KNL nodes. First the
teca_metadata_probe was used to determine the number of MPI ranks based on the
input dataset (see 1_run_planning.sh).  After a number of post detection
analyses are run (see 3_TC_track_analysis.sh)


| script | description |
| ---- | ---- |
| 1_run_planning.sh | Runs the metadata probe to determine the number of time steps |
| 2_GFDL_TC_detect.sh | Runs the TC detector and outputs the number of TC tracks |
| 3_TC_track_analysis.sh | Runs post TC analysis, including wind radii calcs |

