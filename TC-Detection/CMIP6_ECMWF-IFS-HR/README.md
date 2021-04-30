## GFDL TC on CMIP6

Output of 1_run_planning.sh
```
A total of 94964 steps available. Using the gregorian calendar. Times are specified
in units of days since 1950-1-1 00:00:00. The available times range from 1950-1-1
0:0:0 (0) to 2014-12-31 18:0:0 (23740.8).

Mesh dimension: 2D
Mesh coordinates: lon, lat
Mesh extents: 0, 719, 0, 360
Mesh bounds: 0, 359.5, -90, 90

12 data arrays available

  Id    Name     Type         Centering     Dimensions          Shape
-----------------------------------------------------------------------------------
  1     lat      NC_DOUBLE    point 1D      [lat]               [361]
  2     lon      NC_DOUBLE    point 1D      [lon]               [720]
  3     psl      NC_FLOAT     point 2D      [time, lat, lon]    [94964, 361, 720]
  4     ta200    NC_FLOAT     point 2D      [time, lat, lon]    [94964, 361, 720]
  5     ta500    NC_FLOAT     point 2D      [time, lat, lon]    [94964, 361, 720]
  6     time     NC_DOUBLE    point 0D      [time]              [94964]
  7     ua850    NC_FLOAT     point 2D      [time, lat, lon]    [94964, 361, 720]
  8     uas      NC_FLOAT     point 2D      [time, lat, lon]    [94964, 361, 720]
  9     va850    NC_FLOAT     point 2D      [time, lat, lon]    [94964, 361, 720]
  10    vas      NC_FLOAT     point 2D      [time, lat, lon]    [94964, 361, 720]
  11    zg200    NC_FLOAT     point 2D      [time, lat, lon]    [94964, 361, 720]
  12    zg924    NC_FLOAT     point 2D      [time, lat, lon]    [94964, 361, 720]


real	0m31.310s
user	0m0.370s
sys	0m0.318s
```

Output of 2_GFDL_TC_detect.sh
```
srun -N 371 -n 23741 teca_tc_detect --input_file ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt_2D.mcf --sea_level_pressure psl --surface_wind_u uas --surface_wind_v vas --850mb_wind_u ua850 --850mb_wind_v va850 --500mb_temp ta500 --200mb_temp ta200 --1000mb_height zg924 --200mb_height zg200 --candidate_file candidates_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt_1.bin --track_file tracks_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt_1.bin
STATUS: At step 3571 time 892.75 68 candidates detected in 185.005 seconds
STATUS: [0:46912496728960] [/global/cscratch1/sd/loring/teca_testing/TECA/alg/teca_tc_trajectory.cxx:484 4.0.0-74-gaf1148d]
STATUS: Formed 3922 tracks comprised of 128756 of the 5456855 avilable candidates

real	14m54.426s
user	2m25.722s
sys	7m12.615s
```




