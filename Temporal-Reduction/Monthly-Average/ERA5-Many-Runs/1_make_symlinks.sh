#!/bin/bash

in_dir=/global/cscratch1/sd/wcollins/ERA5

globs=('*2t*.nc'    \
    '*sstk.*.nc'    \
    '*msl.*.nc'     \
    '*tcrw.*.nc'    \
    '*tcsw.*.nc')

# descriptive names for each run
names=(e5_2t                \
    e5_sstk                 \
    e5_msl                  \
    e5_tcrw                 \
    e5_tcsw)


# for each dataset in the above list make symlinks
# to hide e5 vs e5p
num=${#names[@]}
echo
echo "symlinking $num datasets ... "
echo
let num=$num-1
for i in `seq 0 $num`
do
    glb=${globs[i]}
    name=${names[i]}

    echo -n "${name} ... "

    pushd . > /dev/null

    mkdir -p ./${name}/in
    cd ./${name}/in

    for f in `ls --color=never ${in_dir}/${glb}`
    do
        ff=`basename $f | sed 's/e5p*\.\(.*\)/e5_\1/'`
        ln -s $f $ff
    done

    popd > /dev/null

    echo OK

done
