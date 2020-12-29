# CASCADE BARD CMIP6_MOHC_HadGEM3-GC31-HM
This example contains batch scripts illustrating detecting ARs(atmospheric rivers)
in a HighResMIP dataset using [TECA](https://github.com/LBL-EESA/TECA)'s
[BARD](https://doi.org/10.5194/gmd-2020-55)(Bayesian AR detector) detector.

The data used in this example is located on NERSC's Cori file system at: 
```
/global/cfs/cdirs/m3522/cmip6/CMIP6_hrmcol/HighResMIP/CMIP6/HighResMIP/MOHC/HadGEM3-GC31-HM/highresSST-present/r1i2p1f1/E3hrPt
```

This 3 hourly dataset spans 64 years of simulated time from 1/1 1950 to 12/31 2014.
In this example IVT was computed from 
wind vector and specificy humidity. A total of 7.8 TB from the input dataset
was processed. The IVT vector, IVT magnitude and AR detection fields were written to disk.
In total 2.3 TB was written.
The data was processed in 13m 54s using 2925 KNL nodes on Cori (198900 cores).

The following scripts were used for the run.

| script name | description |
| :---- | :---- |
| [1_run_planning.sh](1_run_planning.sh) | Scans the dataset. The output is Used to determine the number of Cori nodes needed for the AR detection run. |
| [2_CASCADE_BARD_AR_detect.sh](2_CASCADE_BARD_AR_detect.sh) | Makes the run detecting ARs. |
| [CMIP6_MOHC_HadGEM3-GC31-HM_highresSST-present_r1i2p1f1_E3hrPt.mcf](CMIP6_MOHC_HadGEM3-GC31-HM_highresSST-present_r1i2p1f1_E3hrPt.mcf) | MCF configuration file identifying the location of the HighResMIP data |

