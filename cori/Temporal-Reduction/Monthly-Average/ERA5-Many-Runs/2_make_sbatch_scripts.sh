#!/bin/bash
#SBATCH -C knl
#SBATCH -N 16
#SBATCH -q debug
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -J 1_run_prep
#SBATCH --mail-type all

module use /global/common/software/m1517/teca/cori/develop/modulefiles/
module switch PrgEnv-intel PrgEnv-gnu
module load teca

# create a script to launch the jobs
submit_script=3_submit_runs.sh
echo "#!/bin/bash" > ${submit_script}
chmod 755 ${submit_script}

# output file names
of_names=('e5_oper.an.sfc.128_167_2t.ll025sc' \
    'e5_oper.an.sfc.128_034_sstk.ll025sc' \
    'e5_oper.an.sfc.128_151_msl.ll025sc' \
    'e5_oper.an.sfc.228_089_tcrw.ll025sc' \
    'e5_oper.an.sfc.228_090_tcsw.ll025sc')

# input regexes
rexs=('^e5_.*2t.*\.nc$'    \
    '^e5_.*sstk.*\.nc$'    \
    '^e5_.*msl.*\.nc$'     \
    '^e5_.*tcrw.*\.nc$'    \
    '^e5_.*tcsw.*\.nc$')

# descriptive names for each run
names=(e5_2t                \
    e5_sstk                 \
    e5_msl                  \
    e5_tcrw                 \
    e5_tcsw)

# variable to average for each run
vars=(VAR_2T                \
    SSTK                    \
    MSL                     \
    TCRW                    \
    TCSW)

# a fucntion that writes a sbatch script launching a monthly average run
function write_launcher () {

script=$1
name=$2
rex=$3
var=$4
n_months=$5
out_dir=$6
of_name=$7

n_ranks=${n_months}
ranks_per_node=16
extra_node=$(( n_months % ranks_per_node == 0 ? 0 : 1 ))
n_nodes=$((n_months / ranks_per_node + extra_node))

cat << EOF > ${script}
#!/bin/bash
#SBATCH -N ${n_nodes}
#SBATCH -C knl
#SBATCH -q regular
#SBATCH -t 01:00:00
#SBATCH -A m3875

module use /global/common/software/m1517/teca/cori/develop/modulefiles/
module switch PrgEnv-intel PrgEnv-gnu
module load teca

set -x

rm -rf ${out_dir}
mkdir -p ${out_dir}

time srun -n ${n_ranks} -N ${n_nodes} teca_temporal_reduction \\
    --x_axis_variable longitude --y_axis_variable latitude \\
    --input_regex '${rex}' \\
    --interval monthly --operator average --point_arrays ${var} \\
    --output_file ${out_dir}/${of_name}_%t%.nc \\
    --file_layout yearly \\
    --verbose 0
EOF

chmod 755 ${script}

}

# the metadata file contains a table with run parameters
md_file=run_table.csv
echo "name, var, n_files, n_steps, year_0, year_1, n_years, n_months" > ${md_file}

# for each dataset in the above lists
num=${#rexs[@]}
echo
echo "probing $num datasets ... "
echo
let num=$num-1
for i in `seq 0 $num`
do
    rex="${rexs[i]}"
    name=${names[i]}
    var=${vars[i]}
    of_name=${of_names[i]}

    echo -n "${name} ... "

    in_dir=`pwd`/${name}/in
    out_dir=`pwd`/${name}/out

    mdp_out=./${name}/${name}_${var}_mdp.txt

    # probe the dataset to determine number of months
    if [[ ! -e ${mdp_out} ]]
    then
        srun -N 16 -n 256 teca_metadata_probe \
            --x_axis_variable longitude --y_axis_variable latitude \
            --input_regex "${in_dir}/${rex}" > ${mdp_out} 2>&1
    fi

    # remove newlines from the metadata probe output, makes it a single line of text
    tmp=`cat ${mdp_out} | tr '\n' ' '`

    # extract fields from the text
    n_files=`echo ${tmp} | sed 's/.*\b\([0-9]\+\) files.*/\1/'`
    n_steps=`echo ${tmp} | sed 's/.*\b\([0-9]\+\) steps.*/\1/'`
    year_0=`echo ${tmp} | sed 's/.*from \([0-9][0-9][0-9][0-9]\)-.*/\1/'`
    year_1=`echo ${tmp} | sed 's/.*to \([0-9][0-9][0-9][0-9]\)-.*/\1/'`
    n_years=`echo ${year_1}-${year_0}+1 | bc`
    n_months=`echo ${n_years}*12 | bc`

    # put the fields into the CSV
    echo "${name}, ${var}, ${n_files:-0}, ${n_steps:-0}, ${year_0:-0}, ${year_1:-0}, ${n_years:-0}, ${n_months:-0}" >> ${md_file}

    # generate the sbatch script to do the run
    sbatch_script=./monthly_average_${name}.sbatch
    write_launcher ${sbatch_script} ${name} ${in_dir}/${rex} ${var} ${n_months} ${out_dir} ${of_name}

    echo "sbatch ${sbatch_script}" >> ${submit_script}

    echo OK

done

echo
echo ${md_file}
cat ${md_file}
echo
echo ${submit_script}
cat ${submit_script}
echo
