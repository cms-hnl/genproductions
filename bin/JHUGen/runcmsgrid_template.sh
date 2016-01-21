#!/bin/bash

nevt=${1}
echo "%MSG-MG5 number of events requested = $nevt"

rnum=${2}
echo "%MSG-MG5 random seed used for the run = $rnum"

ncpu=${3}
echo "%MSG-MG5 number of cpus = $ncpu"

eval `scramv1 runtime -sh`

cd BASEDIR/

GENCOMMAND
file=Out.lhe

head=`cat   $file | grep -in init | sed "s@:@ @g" | awk '{print $1-2}' | tail -1`
tail=`wc -l $file | awk -v tmp="$head" '{print $1-2-tmp}'`

tail -${tail} $file                                     >  ${file}_tail_dec
sed "s@\*\*\*@1.000@g"     ${file}_tail_dec              > ${file}_tail
cat ${file}_tail                                       >> cmsgrid.lhe
rm ${file}
rm ${file}_tail
mv cmsgrid.lhe ../cmsgrid_final.lhe
cd ..
