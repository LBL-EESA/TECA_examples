
In this example 5 runs have been downloaded into a single directory.

A monthly average was to be computed for each dataset.

The file names had not followed TECA conventions so symlinks were used to put the dataset into the required conventions.

A script was used to run the teca_mertadata_probe on each dataset to determine the size of the runs. The runs are parallelized over the output time interval, number of months. The script generates batch script to make the runs.

The user would then invoke the generated script to submit the runs.

