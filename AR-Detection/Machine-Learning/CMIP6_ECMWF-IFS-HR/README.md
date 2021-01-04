# TECA deeplab AR Detector on CMIP6_ECMWF-IFS-HR

## About the Dataset
This repo contains batch scripts illustrating detecting ARs(atmospheric rivers)
in a CMIP6 dataset using [TECA](https://github.com/LBL-EESA/TECA)'s
machine learning detector, `teca_deeplab_ar_detect`.

The data used in this example is located on NERSC's Cori file system at:
```
/global/cfs/cdirs/m3522/cmip6/CMIP6_hrmcol/HighResMIP/CMIP6/HighResMIP/ECMWF/ECMWF-IFS-HR/highresSST-present/r1i1p1f1/6hrPlevPt
```

This CMIP6 dataset spans the year 1950 to 2014 with 7 pressure levels at a
1/2 degree spatial and 6 hourly time resolution.  There are 94964 simulated time
steps stored in 780 files which require 290 GB disk space per scalar field.
In this example IVT is calculated on the fly from horizontal wind vector and
specific humidity, thus 870 GB was processed.

## Batch Scripts
The scripts contained in this repo were used to process the above dataset using
100912 cores on 1484 KNL nodes on NERSC's Cray supercomputer Cori. The run
computed the IVT vector, its magnitude, the probability of an AR and a
segmentation of the AR probability. The run completed in 5m 19s and
generated a total of 392 GB of data.

The following scripts were used for the run.

| script name | description |
| :---- | :---- |
| [1_run_planning.sh](1_run_planning.sh) | Scans the dataset. The output is Used to determine the number of Cori nodes needed for the AR detection run. |
| [2_deeplab_AR_detect.sh](2_deeplab_AR_detect.sh) | Makes the run detecting ARs. |
| [HighResMIP_ECMWF...6hrPlevPt.mcf](HighResMIP_ECMWF_ECMWF-IFS-HR_highresSST-present_r1i1p1f1_6hrPlevPt.mcf) | MCF configuration file identifying the location of the HighResMIP data |

These can be used as a template for making other similar runs. One will need to
modify the paths in the scripts to point to a TECA install, and modify the MCF
file to point to the desired dataset.

## Node Level Parallelism

PyTorch can make use of OpenMP or GPUs for node level parallelism. When running
on Cori, TECA configures torch for use with OpenMP such that each rank has
thread pools where individual threads are bound to a unique core accounting for
all thread pools on all ranks running on the same node. By default the thread
pools will not use more than 4 threads. These settings were determined to work
well on Cori KNL nodes. One may explicitly override the defaults by using a
combination of OpenMP environment variables and SLURM srun command line
options. See [PyTorch Node Level Parallelism](pytorch_parallelism/README.md)
for more information.

