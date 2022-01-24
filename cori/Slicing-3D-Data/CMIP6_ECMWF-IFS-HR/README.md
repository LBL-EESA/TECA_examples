## Slicing 3D Data

This example shows how to slice a 3D CMIP6 dataset to extract the fields needed
for the GFDL TC detector.

To run the GFDL tc detector we need:

1. Sea level pressure
2. Surface wind vector
3. 850 mB wind vector
4. 500 mB temperature
5. 200 mB temperature
6. 1000 mB geopotential height
7. 200 mB geopotential height

Sea level pressure and surface winds will be provided on a 2D mesh, but the
fields required at specific vertical presssure levels will need to be
interpolated from the 3D input onto a 2D slice of the same dimensions and
resolution as the seal level pressure and surface winds.

### Run prep
The output of `1_run_planning.sh` shows 94964 time steps

```
A total of 94964 steps available. Using the gregorian calendar. Times are specified
in units of days since 1950-1-1 00:00:00. The available times range from 1950-1-1
0:0:0 (0) to 2014-12-31 18:0:0 (23740.8).

Mesh dimension: 3D
Mesh coordinates: lon, lat, plev
Mesh extents: 0, 719, 0, 360, 0, 6
Mesh bounds: 0, 359.5, -90, 90, 92500, 5000

8 data arrays available

  Id   Name    Type         Centering     Dimensions                Shape
------------------------------------------------------------------------------------------
  1    lat     NC_DOUBLE    point 1D      [lat]                     [361]
  2    lon     NC_DOUBLE    point 1D      [lon]                     [720]
  3    plev    NC_DOUBLE    point 1D      [plev]                    [7]
  4    ta      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]
  5    time    NC_DOUBLE    point 0D      [time]                    [94964]
  6    ua      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]
  7    va      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]
  8    zg      NC_FLOAT     point 3D      [time, plev, lat, lon]    [94964, 7, 361, 720]
```

### Runs

The `2_slice_data.sh` script loops over each field and corresponding pressure
level to compute the slice across all time steps.

Each 3D input field is 242 GB.
Each output 2D filed is 92 GB.

On average the slices took 1 minute and 2 seconds to compute.

Run time for the 1024 node, 16 rank per node, monthly run
```
$sacct -j 42039198 -o JobId%16,JobName%18,NNodes,NTasks,Elapsed,MaxDiskRead,MaxDiskWrite,MaxRSS
           JobID            JobName   NNodes   NTasks    Elapsed  MaxDiskRead MaxDiskWrite     MaxRSS
---------------- ------------------ -------- -------- ---------- ------------ ------------ ----------
        42039198       2_slice_data     1024            00:06:25
  42039198.batch              batch        1        1   00:06:25        6.23M        2.64M     24071K
 42039198.extern             extern     1024     1024   00:06:27        0.00M            0       141K
      42039198.0   teca_cf_restripe     1024    16384   00:00:55       13.59M      129.02M     79420K
      42039198.1   teca_cf_restripe     1024    16384   00:00:54       14.26M      129.02M     75522K
      42039198.2   teca_cf_restripe     1024    16384   00:01:09        8.30M      129.02M     77260K
      42039198.3   teca_cf_restripe     1024    16384   00:01:11        8.31M      129.02M     77193K
      42039198.4   teca_cf_restripe     1024    16384   00:01:06        9.67M      129.02M     68155K
      42039198.5   teca_cf_restripe     1024    16384   00:00:55       14.18M      129.02M     75518K
```

Run time for the 1024 node, 16 rank per node, yearly run
```
$sacct -j 42083526 -o JobId%16,JobName%18,NNodes,NTasks,Elapsed,MaxDiskRead,MaxDiskWrite,MaxRSS
           JobID            JobName   NNodes   NTasks    Elapsed  MaxDiskRead MaxDiskWrite     MaxRSS
---------------- ------------------ -------- -------- ---------- ------------ ------------ ----------
        42083526 2_slice_data_year+     1024            00:14:08
  42083526.batch              batch        1        1   00:14:08        6.64M        2.73M     23936K
 42083526.extern             extern     1024     1024   00:14:10        0.00M            0       137K
      42083526.0   teca_cf_restripe     1024    16384   00:05:07       13.59M     1457.57M     79487K
      42083526.1   teca_cf_restripe     1024    16384   00:01:53       14.31M     1457.57M     79534K
      42083526.2   teca_cf_restripe     1024    16384   00:01:46        8.31M     1457.57M     77144K
      42083526.3   teca_cf_restripe     1024    16384   00:01:44        8.31M     1457.57M     77413K
      42083526.4   teca_cf_restripe     1024    16384   00:01:48        9.67M     1457.57M     77380K
      42083526.5   teca_cf_restripe     1024    16384   00:01:46       14.15M     1457.57M     77110K
```

Note: run times are similar, the first step in the yearly run took 5x longer
than any other run, it's likely an outlier/system hicup.
