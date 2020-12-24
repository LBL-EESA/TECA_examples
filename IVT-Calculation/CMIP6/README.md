HighResMIP-IVT-Calculation
==========================
This repo contains batch scripts illustrating computing IVT(integrated vapor
transport) from a HighResMIP dataset using [TECA](https://github.com/LBL-EESA/TECA).

The data used in this example is located on NERSC's Cori file system at:
```
/global/cfs/cdirs/m3522/cmip6/CMIP6_hrmcol/HighResMIP/CMIP6/HighResMIP/ECMWF/ECMWF-IFS-HR/highresSST-present/r1i1p1f1/6hrPlevPt
```

This HighResMIP dataset spans the year 1950 to 2014 with 7 pressure levels at a
1 degree spatial and 6 hourly time resolution.  There are 94964 simulated time
steps stored in 780 files which require 290 GB disk space per scalar field.

The IVT calculation makes use of horizontal wind vector and specific humidity,
thus 870 GB was processed.

The scripts contained in this repo were used to process the above dataset using
100912 cores on 1484 KNL nodes on NERSC's Cray supercomputer Cori. The run
computed the IVT vector and its magnitude. The run completed in 2m 49s and
generated a total of 276 GB of data.

2 batch scripts were used for the run.

| script name | description |
| :---- | :---- |
| [1_run_planning.sh](1_run_planning.sh) | Scans the dataset. The output is Used to determine the number of Cori nodes needed for the IVT calculation. |
| [2_IVT_calculation.sh](2_IVT_calculation.sh) | Makes the run computing IVT. |
| [HighResMIP_ECMWF...6hrPlevPt.mcf](HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt.mcf) | MCF configuration file identifying the location of the HighResMIP data |

These can be used as a template for making other similar runs. One will need to
modify the paths in the scripts to point to a TECA install, and modify the MCF
file to point to the desired HighResMIP dataset.
