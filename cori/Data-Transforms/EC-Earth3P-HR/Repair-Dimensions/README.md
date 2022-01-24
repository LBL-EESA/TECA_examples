# Repair EC-Earth-3P data

The problems for this dataset:

1. In all but 3 of the files hus is dimensioned with integer indices j,i. This
   is an issue for some algorithms that operate on lat, lon coordinates. we
   use TECA to transform these j,i indices into lat,lon coordinates

2. In 3 of the files hus is dimensioned with lon, lat values. in the files
   with j,i indices there are additional arrays latitude and longitude which
   changes the structure of the file. This is an issue for TECA because it
   assumes that all files in the dataset have the same internal structure
   at the NetCDF level.

The repair is made using

```
$ sbatch 1_repair_data.sh
```

in this dataset each file stores a year's worth of data. in [1_repair_data.sh](1_repair_data.sh)
we loop over the files determine the number of time steps from which we can set
the run size. we check for the j,i dimensions on hus and if found we apply a
transform to lat,lon dimensions. this is done via the MCF reader, and the MCF
file is needed for these files. When the j,i indices are not present we rewrite
the file to be sure that all the files have the same structure.

each file had 1460 or 1461 steps. running at that concurency took
approximately 2 min per file on Cori KNL.

We check the result by comparing the original to the new

```
# original
srun -n 64 teca_metadata_probe --input_file ./ece3p_hr_hrsst_pres_r3i1p1f1_6hrPlevPt_hus_ij.mcf

# new
srun -n 64 teca_metadata_probe --input_regex ./repaired_data/hus_6hrPlevPt_EC-Earth3P-HR_highresSST-present_r3i1p1f1_gr_'.*\.nc$'
```


