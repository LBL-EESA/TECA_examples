### Processing multiple datasets automatically

In this example 5 ERA5 datasets have been downloaded into a single directory. A monthly average is to be computed for each dataset.

The file names had not followed TECA conventions of lexographical ordering of file names along the time dimension. Symlinks were used to put the dataset into the required conventions. See [1_make_symlinks.sh](1_make_symlinks.sh)

A second script was used to run the teca_mertadata_probe on each dataset to determine the size of the runs. For temporal reductions runs are parallelized over the output time interval. In this case the number of months. The script creates a table with a row for each dataset which is useful for validation See [run_table.csv](run_table.csv). The script also generates SLURM batch scripts for each dataset (For example [monthly_average_e5_2t.sbatch](monthly_average_e5_2t.sbatch)). A script that submits the generated sbatch scripts to SLURM is also generated. See [3_submit_runs.sh](3_submit_runs.sh). This script is invoked to submit the runs.
