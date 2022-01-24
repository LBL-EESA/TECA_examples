# TECA ARDT Example

Gives an example of implementing a basic atmospheric river detector (ARDT) with
TECA.

## Overview

This example implements a simple ARDT that detects regions with integrated vapor
transport (IVT) greater than or equal to 250 kg/m/s outside the latitudes
15S-15N.  Regions that match these conditions are given the value 1, and regions
that don't are given the value 0.  This variable is written to netCDF with the
name `ar_binary_tag`.

This provides an example of a TECA algorithm (`teca_ardt_example`) that performs
a simple transformation on a scalar input field: in this case, mapping `IVT` ->
`ar_binary_tag`.  The function `ar_detect_basic()` performs this transformation.
This example can be used to build other similar pipelines that do 1:1
transformations.

This example code was developed by first implementing the `ar_detect_basic()`
function outside the TECA framework; here, a Jupyter notebook was used for the
initial development.  The function was then wrapped into a TECA algorithm and
tested at NERSC.  The final version of `ar_detect_basic()` differs slightly from
the Jupyter notebook implementation because the testing/debugging process led to
a few minor changes.

The script that tests the code, `test_ardt_era5.bash` runs the application on 4
nodes and 128 processors.  This was a somewhat arbitrary choice.  The motivation
was to use enough processors that the test ran quickly, but few enough nodes
that the `salloc -C haswell -q interactive -N 4 -t 30` command returned a
command prompt immediately in order to facilitate real-time debugging.  In
real-world use-cases with this example code, the number of processors could
scale up to the nubmer of timesteps in the output file (which is identical to
the number of timesteps in the input file, since the entire input dataset is
processed in this example).

## Description of files

 * `Develop and validate simple ARDT.ipynb` - a Jupyter notebook that implements the ARDT in python and demonstrates that it works as expected
 * `teca_ardt_example.py` - contains the ARDT function `ar_detect_basic()` and the TECA python algorithm that wraps that function `teca_ardt_example`
 * `teca_ardt_example_detect` - a Python application that sets up a TECA-based pipeline that includes the `teca_ardt_example` pipeline stage
 * `test_ardt_era5.bash` - a bash script that runs the ARDT application on one year of ERA 20CR data

## Author information

Travis A. O'Brien <obrienta@iu.edu>