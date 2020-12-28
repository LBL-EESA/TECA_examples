



```bash
$ module use ...
$ module load teca
$ srun -N 12 -n 780 teca_metadata_probe --z_axis_variable plev --input_file CMIP6_MOHC_HadGEM3-GC31-HM_highresSST-present_r1i2p1f1_E3hrPt.mcf

A total of 187199 steps available. Using the 360_day calendar. Times are specified
in units of days since 1950-01-01. The available times range from 1950-1-1
3:0:0 (0.125) to 2014-12-30 21:0:0 (23399.9).

Mesh dimension: 3D
Mesh coordinates: lon, lat, plev

7 data arrays available

  Id   Name    Type         Dimensions                Shape
-------------------------------------------------------------------------
  1    hus     NC_FLOAT     [time, plev, lat, lon]    [187199, 7, 768, 1024]
  2    lat     NC_DOUBLE    [lat]                     [768]
  3    lon     NC_DOUBLE    [lon]                     [1024]
  4    plev    NC_DOUBLE    [plev]                    [7]
  5    time    NC_DOUBLE    [time]                    [187199]
  6    ua      NC_FLOAT     [time, plev, lat, lon]    [187199, 7, 769, 1024]
  7    va      NC_FLOAT     [time, plev, lat, lon]    [187199, 7, 769, 1024]


real	0m11.934s
user	0m0.345s
sys	0m0.336s

```

# 187199 steps / 8 steps per rank = 23400 ranks
# 68 cores per node / 8 cores per rank = 8 ranks per node
# 23400 ranks / 8 ranks per node = 2925 nodes


```
$ module use ...
$ module load teca
TECA (missing_values)
+ out_dir=CMIP6_MOHC_HadGEM3-GC31-HM_highresSST-present_r1i2p1f1_E3hrPt/CASCADE_BARD_all
+ mkdir -p CMIP6_MOHC_HadGEM3-GC31-HM_highresSST-present_r1i2p1f1_E3hrPt/CASCADE_BARD_all
+ srun -N 2925 -n 23400 teca_bayesian_ar_detect --input_file CMIP6_MOHC_HadGEM3-GC31-HM_highresSST-present_r1i2p1f1_E3hrPt.mcf --specific_humidity hus --wind_u ua --wind_v va --ivt_u ivt_u --ivt_v ivt_v --ivt ivt --compute_ivt --write_ivt --write_ivt_magnitude --steps_per_file 128 --output_file CMIP6_MOHC_HadGEM3-GC31-HM_highresSST-present_r1i2p1f1_E3hrPt/CASCADE_BARD_all/CASCADE_BARD_AR_%t%.nc
STATUS: [0:46912496725824] [/global/cscratch1/sd/loring/teca_testing/TECA_superbuild/build-missing_values/TECA-prefix/src/TECA/io/teca_cf_reader.cxx:233 TECA-BARD-v1.0.1-284-g6893dc4]
STATUS: Using 1024 of 23400 MPI ranks  to read the time axis
STATUS: [0:46912496725824] [/global/cscratch1/sd/loring/teca_testing/TECA_superbuild/build-missing_values/TECA-prefix/src/TECA/io/teca_cf_reader.cxx:233 TECA-BARD-v1.0.1-284-g6893dc4]
STATUS: Using 1024 of 23400 MPI ranks  to read the time axis
STATUS: [0:46912496725824] [/global/cscratch1/sd/loring/teca_testing/TECA_superbuild/build-missing_values/TECA-prefix/src/TECA/io/teca_cf_reader.cxx:233 TECA-BARD-v1.0.1-284-g6893dc4]
STATUS: Using 1024 of 23400 MPI ranks  to read the time axis

real	13m54.162s
user	0m3.181s
sys	0m6.916s

```
